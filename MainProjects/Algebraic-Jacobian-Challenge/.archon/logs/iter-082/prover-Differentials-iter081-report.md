# AlgebraicJacobian/Differentials.lean — iter-081 report

## Outcome

**Sorry count: 5 → 5 (no regression).** The `Derivation.postcomp_comp` helper landed
fully closed. `h_zero` of `cotangentExactSeq_structure` was successfully closed
via Route (c) but the `_structure` body was reverted to a single absorbed `sorry`
because `h_epi` could not be closed in the same iteration without typeclass coercion
infrastructure that does not yet exist in the file.

The plan's conditional clause was respected: with `h_epi` unable to close, the
iter-081 plan said "preserve iter-080 state and document precisely what failed".

## Helpers landed (this iteration)

### `_root_.PresheafOfModules.Derivation.postcomp_comp` — fully closed (L455–465)

```
@[simp]
lemma _root_.PresheafOfModules.Derivation.postcomp_comp
    {C : Type*} [Category C] {D : Type*} [Category D]
    {F : C ⥤ D} {S : Cᵒᵖ ⥤ CommRingCat} {R : Dᵒᵖ ⥤ CommRingCat}
    {M N P : _root_.PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)}
    {φ : S ⟶ F.op ⋙ R}
    (d : M.Derivation φ) (f : M ⟶ N) (g : N ⟶ P) :
    d.postcomp (f ≫ g) = (d.postcomp f).postcomp g := by
  ext X b
  simp only [_root_.PresheafOfModules.Derivation.postcomp_d_apply,
             _root_.PresheafOfModules.comp_app]
  rfl
```

Two structural notes:
- Inside the namespace `AlgebraicGeometry.Scheme`, `PresheafOfModules` shadows the
  Mathlib root. Use `_root_.PresheafOfModules` for cross-namespace lemmas.
- After `simp only [postcomp_d_apply, comp_app]` the residual goal is
  `(f.app X ≫ g.app X).hom (d.d b) = (g.app X).hom ((f.app X).hom (d.d b))`,
  which closes by `rfl` (composition in `ModuleCat` IS `LinearMap.comp` at the
  `.hom` level; `simp only` does not fire on `ModuleCat.hom_comp` here because
  the LHS does not present in the rewriter's expected shape, but `rfl` recovers).

## `cotangentExactSeq_structure` (L514–542)

### Route (c) successful for `h_zero` — verified working

The full chain that closes `h_zero` was implemented and verified compiling in this
iteration. It is preserved as a comment block in the body for iter-082+. Key steps:

```
apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
unfold cotangentExactSeqAlpha
simp only [Equiv.apply_symm_apply]
apply SheafOfModules.hom_ext
change (PresheafOfModules.DifferentialsConstruction.isUniversal' _).desc _ ≫
    (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).map
      (cotangentExactSeqBeta f g).val = 0
apply (PresheafOfModules.DifferentialsConstruction.isUniversal' _).postcomp_injective
rw [PresheafOfModules.Derivation.postcomp_comp]
simp only [PresheafOfModules.Derivation.Universal.fac]
apply PresheafOfModules.Derivation.ext
ext U b
-- ...set φ_g'/φ_fg'/φ_2'/adj_f, build hcoh, hcoh_app, hd_app, hβ_fac...
simp only [PresheafOfModules.Derivation.postcomp_d_apply]
dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
unfold cotangentExactSeqBeta
change (((isUniversal' φ_fg').desc _).app
    (op ((Opens.map f.base).obj U.unop))).hom
      ((derivation' φ_fg').d ((f.c.app U).hom b)) = _
rw [hβ_fac _ ((f.c.app U).hom b)]
rw [hd_app]
rfl
```

Validation: this chain successfully closes the `h_zero` goal (`lean_diagnostic_messages`
reported no errors when only the `h_exact` and `h_epi` sub-claims remained pending).

**Sidesteps achieved by Route (c):**
- The iter-080 inline-`d_target` matcher pathology (a metavariable unification
  failure when `rw [hα_fac _ b]` tried to unify the universal `d_t` with the inline
  `d_target` from `cotangentExactSeqAlpha`'s body) is bypassed entirely: we never
  need to rewrite through the inline `d_target`. Instead, `Derivation.postcomp_comp`
  collapses the composition before the inline structure is exposed, and `Universal.fac`
  then rewrites `(derivation' φ_g').postcomp (desc d_target) ↦ d_target` cleanly.
- The same `hβ_fac` trick (parametrizing over an abstract `d_t`) DOES work cleanly
  for the β-side, because at that point we are at the bottom of the descent chain
  and the inline `d1` from `cotangentExactSeqBeta` matches the universal `d_t`.

### Blocker for `h_epi` (the immediate next step)

After `apply SheafOfModules.epi_of_epi_presheaf`, the goal reduces (via
`PresheafOfModules.epi_iff_surjective`) to: for each `U`, the map
`((cotangentExactSeqBeta f g).val.app U).hom` is surjective. Unfolding β makes
this `(d1.app U.unop).desc.hom`, where `d1` is the inline φ_fg'-derivation valued
in `relativeDifferentials' φ_2'` with `d1.d = (derivation' φ_2').d`.

The mathematical content: this descent sends `D b ↦ D' b` (universal element of
target). By `KaehlerDifferential.span_range_derivation`, `{D' b}` spans the codomain.
Linear extension gives surjectivity.

**The blocker**: when attempting `Submodule.mem_top` / `Submodule.span_induction`
on `y : (relativeDifferentials f).val.obj U`, Lean fails to synthesize
`Module ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)`. The reason is
that the natural module instance on `(relativeDifferentials f).val.obj U` is over
`(X.presheaf ⋙ forget₂ CommRingCat RingCat).obj U` (the forget₂-image), not directly
over `X.presheaf.obj U`. The two are the same underlying ring but different
categorical types, and instance synthesis does not bridge them.

Mitigation routes for iter-082+:
1. **Coerce via `change`**: write `change ∃ x, _ = (y : _root_.KaehlerDifferential A B)`
   and supply the `Algebra A B := (φ_2'.app U).hom.toAlgebra` `letI` — attempted
   this iteration; the `change` succeeds but the subsequent `Submodule.mem_top y`
   still fails because the type of `y` after `change` is the coerced form, but
   `Submodule.mem_top` needs the original ModuleCat-valued type with its instance.
2. **Identify the descent with `CommRingCat.KaehlerDifferential.map`**: build an
   explicit coherence square `fac : η.app U ≫ φ_2'.app U = φ_fg'.app U ≫ 𝟙`
   (using `hη` from inside `cotangentExactSeqBeta`'s body) and use Mathlib's
   `CommRingCat.KaehlerDifferential.map_d` + `KaehlerDifferential.ext` to show
   `(d1.app U.unop).desc = CommRingCat.KaehlerDifferential.map fac`. Then
   `KaehlerDifferential.map_surjective_of_surjective` (with `surjective_id`)
   closes surjectivity. This is the "structural" route — requires extracting `hη`
   from `cotangentExactSeqBeta`'s body or recomputing it inline.
3. **Direct construction of preimage via section**: build a section
   `g : KaehlerDifferential (φ_2'.app U) → KaehlerDifferential (φ_fg'.app U)`
   sending `D' b ↦ D b` and show `(d1.app U.unop).desc ∘ g = id`. The right
   inverse needs `KaehlerDifferential.lift` machinery (the universal property
   applied to the target's universal derivation viewed as a φ_fg'-derivation
   via the η-coherence). This is essentially Route 2 in disguise.

### Blocker for `h_exact`

Independent of `h_epi`: requires the `SheafOfModules.exact_iff_stalkwise` helper
(authorised by the plan to carry `sorry` body, 1-for-1 shift). This iteration
introduced and reverted it because `h_epi` could not close in tandem (would have
been a regression 5 → 6). Iter-082+ should reintroduce.

## Iter-082+ recipe (concrete)

1. Reinstate `SheafOfModules.exact_iff_stalkwise` with `sorry` body (1 new sorry).
2. Reinstate the Route (c) chain for `h_zero` (closes `h_zero`).
3. Close `h_exact` via `exact SheafOfModules.exact_iff_stalkwise _` (1-for-1
   shift complete).
4. Close `h_epi` via Route 2 above (identify descent with `KaehlerDifferential.map`).

Net delta iter-082+: 5 → 5 (the `exact_iff_stalkwise` sorry replaces the `_structure`
body sorry).

## Mathlib leverage verified this iteration

- `PresheafOfModules.Derivation` extensibility (`@[ext]` works with `ext X b`).
- `PresheafOfModules.Derivation.postcomp_d_apply` (`@[simps! d_apply]` auto-generated).
- `PresheafOfModules.Derivation.Universal.fac` (`@[simp]` — fires automatically
  in `simp only` calls).
- `PresheafOfModules.Derivation.congr_d` for pointwise extraction.
- `_root_.KaehlerDifferential.span_range_derivation` (the codomain is spanned
  by `D b`'s).
- `Adjunction.homEquiv_naturality_right`, `Adjunction.homAddEquiv_zero`,
  `Equiv.apply_symm_apply`.
- `SheafOfModules.hom_ext`, `SheafOfModules.epi_of_epi_presheaf` (iter-079,
  fully closed).
- `PresheafOfModules.epi_iff_surjective`.

## Approaches ruled out this iteration

- `simp only [pushforward_map_app_apply]` does not fire on
  `((PresheafOfModules.pushforward (Hom.toRingCatSheafHom f).hom).map _).app U .hom m`
  in our shape — the lemma is rfl-level but the simp pattern does not match.
  Use `change ((isUniversal' _).desc _).app (op (f⁻¹ U.unop)) .hom _ = _` instead.
- `apply SheafOfModules.hom_ext` followed by `rfl` does not close (`.val` of
  composition not definitionally `0.val`).
- `rw [← KaehlerDifferential.span_range_derivation]` on `⊤ ≤ range _` fails to
  find `⊤` even when `_root_`-qualified — the typeclass instance for the
  Module structure on the codomain `(relativeDifferentials f).val.obj U` is
  not the one expected by `span_range_derivation` (forget₂-image scalar mismatch).

## Blueprint markers (read-only summary for review agent)

- `PresheafOfModules.Derivation.postcomp_comp` (this iter): no blueprint entry —
  it is a Mathlib-shape generic lemma, not a project deliverable.
- `cotangentExactSeq_structure`: still `sorry` in body — blueprint should not
  carry `\leanok` on the proof block.
