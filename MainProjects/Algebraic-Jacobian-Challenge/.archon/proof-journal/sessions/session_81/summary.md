# Session 81 — iter-081 review

## Metadata

- **Archon iteration**: 081
- **Stage**: prover (two substantive lanes — BasicOpenCech, Differentials; Modules/Monoidal off-limits per plan)
- **Sorry count before iter-081**: 14 active syntactic sorry sites.
- **Sorry count after iter-081**: **14** active syntactic sorry sites (verified via per-file `grep` against active source).
  - Per-file: `Differentials.lean` 5; `Cohomology/BasicOpenCech.lean` 6; `Modules/Monoidal.lean` 1; `Jacobian.lean` 1; `Picard/Functor.lean` 1.
- **Net change**: **0** sorries (hard cap respected; closure target not hit on either active lane).
- **Compilation status**: All affected files compile cleanly (verified by 35 `lean_diagnostic_messages` invocations; final state on each lane returns 0 errors).
- **Env state**: 40 source edits, 35 `lean_diagnostic_messages` calls, 9 `lean_goal` checks, 20 lemma searches, 0 `lean_run_code` pre-validation (per user policy).

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | PARTIAL ADVANCE — S2+S3+S4 of the recipe executed inline; alternating-sum form now exposed at the sorry. S5–S8 pending. | 0 (6 → 6) | yes |
| 2 | `Differentials.lean` | PARTIAL — `Derivation.postcomp_comp` helper landed fully closed; `h_zero` Route (c) chain verified working but reverted because `h_epi` could not close in tandem (conditional clause respected). | 0 (5 → 5) | yes |
| 3 | `Modules/Monoidal.lean` | not assigned (deferred pending Mathlib upstream gap) | — | unchanged |

---

## Lane 1 — `BasicOpenCech.lean`: `h_diff_pi_smul_f` body, structural advance

**Status**: PARTIAL ADVANCE. One substantive edit landed; the iter-080 named-per-i `letI` refactor and `set_option maxHeartbeats 800000 in` are both preserved byte-for-byte. The goal at the remaining `sorry` (now L1196 after the inline expansion shifted line numbers) is the explicit alternating-sum decomposition, ready for per-summand R-linearity work in iter-082+.

### Goal trace at the sorry (from `attempts_raw.jsonl`, event 67)

After the inline S2+S3+S4 expansion at L1196:
```
case h
k : Type u; inst✝ : Field k
C : Over (Spec (CommRingCat.of k))
U : TopologicalSpace.Opens ↑C.left.toTopCat
hU : IsAffineOpen U
...
⊢ (piIsoPi Z₂).hom
    (eqToHom _ ∘ₗ
      (∑ i : Fin (prev n + 2), (-1)^↑i •
        Pi.lift (fun j' ↦ Pi.π Z₁ (j' ∘ δ_i.toOrderHom) ≫
          (toModuleKPresheaf C).map (Pi.lift _).op)))
      ((piIsoPi Z₁).symm (r • y)) j
  = r • (piIsoPi Z₂).hom (eqToHom _ ∘ₗ
        (∑ i : Fin (prev n + 2), (-1)^↑i •
          Pi.lift …))
        ((piIsoPi Z₁).symm y) j
```
The two sides differ only at the OUTERMOST `r •` versus the `r • y` argument inside the inverse-of-`piIsoPi`.

### Concrete delivery (event 62)

A single substantive edit at the L1196 sorry: the iter-080 sorry-rationale block was replaced with a 5-layer `dsimp` + full-`simp` invocation that simultaneously:

1. Establishes `hRel : (ComplexShape.up ℕ).prev n + 1 = n` via case-split (`rcases n; simp [ComplexShape.prev, ComplexShape.up_Rel]`) — collapses S3's `(up ℕ).Rel` opacity that blocked iter-076/078/079.
2. Unfolds the 5-layer functor stack: `scK₀ → K₀ → cechCochain → cechComplexFunctor → toModuleKSheaf` (S2).
3. Inside the same `simp` call, simp set includes
   `[FormalCoproduct.cochainComplexFunctor, cosimplicialObjectFunctor,
     AlgebraicTopology.alternatingCofaceMapComplex, AlternatingCofaceMapComplex.obj,
     AlternatingCofaceMapComplex.objD, AlternatingCofaceMapComplex.map,
     CochainComplex.of, FormalCoproduct.evalOp, e₁, e₂, ModuleCat.piIsoPi,
     dif_pos hRel]`.
4. The `dif_pos hRel` term inside the full `simp` (not `simp only`) is what flushes `CochainComplex.of_d` to the `then` branch — this is the trick the iter-080 plan recipe missed (it proposed `CochainComplex.of_d_eq_succ`, which does not exist in Mathlib).

### Attempts tried, errors logged

| Tactic | Result | Diagnostic |
|---|---|---|
| `rcases n; simp [ComplexShape.prev, ComplexShape.up_Rel]` to establish `hRel` | ✓ closes the case-split | event 71 clean |
| 5-layer `dsimp` + full `simp [...]` chain with `dif_pos hRel` inside the set | ✓ STRUCTURAL ADVANCE | clean diagnostic; goal at sorry is the alternating-sum form above |
| `simp only` variant of the same simp set | ✗ FAIL | does not collapse `CochainComplex.of_d` (lacks the elaboration `simp` performs) |
| `rw [dif_pos hRel]` AFTER a `simp only` chain | ✗ FAIL | conditional `dite` not yet present in the goal — only the wrapped `K₀.d` projection |
| `rw [CochainComplex.of_d_eq_succ ...]` | ✗ FAIL | lemma does not exist in Mathlib (iter-080 plan's recipe error) |

### Sorry-count budget

- 6 (start) → 6 (end). Hard cap respected. Target (≤ 5 = close `h_diff_pi_smul_f`) **NOT hit**.
- The structural advance unblocks S5–S8: the per-summand R-linearity decomposition (distribute `e₂ = piIsoPi Z₂` and the alternating sum through `Pi.lift`, then `Pi.π Z₁ k (e₁.symm z) = z k` from `piIsoPi_inv_kernel_ι`, then `Finset.smul_sum` + per-summand `RingHom.map_mul` + `← presheaf.map_comp` to collapse the two restrictions).
- The detailed recipe is now inline in the body (replacing the iter-080 rationale block). Estimated ~30 LOC for full closure given S2+S3+S4 are done.

### Approaches ruled out (preserved into iter-082+ as DEAD-END warnings inline)

- `simp only` cannot replace full `simp` for the S2+S3+S4 chain — full `simp`'s elaboration is required to flush `CochainComplex.of_d` through the dite-branch.
- `CochainComplex.of_d_eq_succ` is NOT a Mathlib lemma (the iter-080 plan recipe's proposal); use `dif_pos hRel` *inside* a full simp call instead.
- `rw [dif_pos hRel]` after a `simp only` chain — the conditional `dite` is not yet present in the goal at that stage.

---

## Lane 2 — `Differentials.lean`: `Derivation.postcomp_comp` helper + `cotangentExactSeq_structure` Route (c) closed-then-reverted

**Status**: PARTIAL. The third permitted helper `Derivation.postcomp_comp` landed fully closed at L455–465 (Mathlib-shape lemma; one-line proof via `ext + simp only [postcomp_d_apply, comp_app] + rfl`). The Route (c) chain for `h_zero` was implemented and verified compiling cleanly when only `h_exact` and `h_epi` remained pending — but `h_epi` could not close in the same iteration without typeclass coercion infrastructure that did not yet exist in the file, so the body was reverted to a single absorbed `sorry`. The plan's conditional clause was respected: "if Route (c) AND Route (a) both fail, do NOT introduce `exact_iff_stalkwise` as a free-floating sorry — that would be a regression (5 → 6)."

### Concrete delivery: `Derivation.postcomp_comp` (L455–465, fully closed)

```lean
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

Two structural points:
- `_root_.PresheafOfModules` disambiguation is required: inside `AlgebraicGeometry.Scheme`, `PresheafOfModules` shadows the Mathlib root.
- After `simp only [postcomp_d_apply, comp_app]` the residual goal is `(f.app X ≫ g.app X).hom (d.d b) = (g.app X).hom ((f.app X).hom (d.d b))`, which closes by `rfl` (composition in `ModuleCat` IS `LinearMap.comp` at the `.hom` level; `simp only` does not fire on `ModuleCat.hom_comp` here because the LHS does not present in the rewriter's expected shape, but `rfl` recovers).

### `h_zero` Route (c) — verified working then reverted

The full chain for `h_zero` was implemented and verified compiling (event 122/123 returned 0 errors when only `h_exact` and `h_epi` sub-claims were pending). It is preserved as a comment block in the body of `cotangentExactSeq_structure` at L507–525 for iter-082+:

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

**Sidesteps vs. iter-080 Route A pathology**:
- The iter-080 inline-`d_target` matcher pathology (metavariable unification failure when `rw [hα_fac _ b]` tried to unify the universal `d_t` with the inline `d_target` from `cotangentExactSeqAlpha`'s body) is bypassed entirely: we never need to rewrite through the inline `d_target`. Instead `Derivation.postcomp_comp` collapses the composition BEFORE the inline structure is exposed, and `Universal.fac` then rewrites `(derivation' φ_g').postcomp (desc d_target) ↦ d_target` cleanly.
- The same `hβ_fac` trick (parametrizing over an abstract `d_t`) DOES work cleanly for the β-side because at that point we are at the bottom of the descent chain and the inline `d1` from `cotangentExactSeqBeta` matches the universal `d_t`.

### `h_epi` blocker (the immediate next step)

After `apply SheafOfModules.epi_of_epi_presheaf`, the goal reduces (via `PresheafOfModules.epi_iff_surjective`) to: for each `U`, the map `((cotangentExactSeqBeta f g).val.app U).hom` is surjective. Unfolding β makes this `(d1.app U.unop).desc.hom`, where `d1` is the inline φ_fg'-derivation valued in `relativeDifferentials' φ_2'` with `d1.d = (derivation' φ_2').d`.

Mathematical content: this descent sends `D b ↦ D' b` (universal element of target). By `KaehlerDifferential.span_range_derivation`, `{D' b}` spans the codomain. Linear extension gives surjectivity.

**Blocker**: when attempting `Submodule.mem_top` / `Submodule.span_induction` on `y : (relativeDifferentials f).val.obj U`, Lean fails to synthesize `Module ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)`. The reason: the natural module instance on `(relativeDifferentials f).val.obj U` is over `(X.presheaf ⋙ forget₂ CommRingCat RingCat).obj U` (the forget₂-image), not directly over `X.presheaf.obj U`. The two are the same underlying ring but different categorical types, and instance synthesis does not bridge them.

### Attempts tried, errors logged (Differentials, 39 edits)

| Tactic | Result | Diagnostic |
|---|---|---|
| Landing `Derivation.postcomp_comp` with `ext X b; simp only [postcomp_d_apply, comp_app]; rfl` | ✓ FULLY CLOSED | event 112/122 clean; no `sorry` in body |
| `_root_.PresheafOfModules` qualifier added to all four occurrences (avoid name shadow inside `Scheme` namespace) | ✓ required for elaboration | event 107 reported `failed to synthesize` without it |
| Route (c) chain in `h_zero` (full chain above) | ✓ STRUCTURAL CLOSURE | event 122/123 clean when only `h_exact`+`h_epi` remained pending |
| `apply SheafOfModules.epi_of_epi_presheaf` + `PresheafOfModules.epi_iff_surjective` + try `Submodule.mem_top y` | ✗ FAIL | `failed to synthesize Module ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)` — forget₂-image module instance not unified with `X.presheaf.obj U` instance |
| `change ∃ x, _ = (y : _root_.KaehlerDifferential A B)` + `letI : Algebra A B := (φ_2'.app U).hom.toAlgebra` | ✗ FAIL | `change` succeeds; subsequent `Submodule.mem_top y` still fails because the type of `y` after `change` is the coerced form, but `Submodule.mem_top` needs the original ModuleCat-valued type with its instance |
| `rw [← KaehlerDifferential.span_range_derivation]` on `⊤ ≤ range _` even with `_root_`-qualified | ✗ FAIL | typeclass instance for the Module structure on the codomain `(relativeDifferentials f).val.obj U` is not the one expected by `span_range_derivation` (forget₂-image scalar mismatch) |
| `simp only [pushforward_map_app_apply]` on `((PresheafOfModules.pushforward (Hom.toRingCatSheafHom f).hom).map _).app U .hom m` | ✗ FAIL | the lemma is rfl-level but the simp pattern does not match in our shape |
| `apply SheafOfModules.hom_ext; rfl` | ✗ FAIL | `.val` of composition not definitionally `0.val` |

### Reversion rationale

Per the plan's iter-081 conditional clause: with Route (c) succeeding on `h_zero` but `h_epi` unable to close (typeclass coercion infrastructure missing), introducing `exact_iff_stalkwise` as a free-floating sorry to claim `h_exact` would have shifted from a single absorbed sorry (the `_structure` body) to two sorries (`exact_iff_stalkwise` body + the still-open `h_epi`) — i.e. a 5 → 6 regression. The prover correctly reverted to preserve the conditional and document everything inline + in the task result.

### Iter-082+ recipe (concrete, from the prover's report)

1. Reinstate `SheafOfModules.exact_iff_stalkwise` with `sorry` body (1 new sorry).
2. Reinstate the Route (c) chain for `h_zero` (closes `h_zero`).
3. Close `h_exact` via `exact SheafOfModules.exact_iff_stalkwise _` (1-for-1 shift complete).
4. Close `h_epi` via the structural identification of the descent with `CommRingCat.KaehlerDifferential.map` using the η-coherence square, then apply `KaehlerDifferential.map_surjective_of_surjective`. The η-coherence (`hη`) is currently inside `cotangentExactSeqBeta`'s body — extract or recompute inline.

Net iter-082+ delta: 5 → 5 (the `exact_iff_stalkwise` sorry replaces the `_structure` body sorry).

---

## Lane 3 — `Modules/Monoidal.lean`: deferred (off-limits this iter)

Not assigned. Mathlib gap (`PresheafOfModules.stalk_tensorObj` for varying-ring R₀) precisely characterized iter-080; downstream consumers use `MonoidalCategory X.Modules` (fully synthesisable) and do not depend on this auxiliary instance. Sorry count unchanged at 1.

---

## Key findings / patterns surfaced

### Pattern (NEW iter-081): `dif_pos hRel` inside a full `simp` to flush `CochainComplex.of_d` through the dite-branch

When the goal contains `K₀.d (prev n) n` and `K₀ = CochainComplex.of` then:

1. Establish `hRel : (ComplexShape.up ℕ).prev n + 1 = n` via `rcases n; simp [ComplexShape.prev, ComplexShape.up_Rel]`.
2. Inside a *full* `simp [...]` invocation that includes `CochainComplex.of`, also include `dif_pos hRel`. The full simp engine performs the elaboration that selects the `then` branch of the `dite` inside `CochainComplex.of_d`, surfacing the `succ`-shape differential.
3. `simp only` cannot do this — the elaboration step is not part of `simp only`'s repertoire.
4. The iter-080 plan's proposed lemma `CochainComplex.of_d_eq_succ` does NOT exist in Mathlib; `dif_pos hRel` inside full `simp` is the correct substitute.

### Pattern (NEW iter-081): `_root_.PresheafOfModules` disambiguation under `Scheme` namespace

Inside the `AlgebraicGeometry.Scheme` namespace, `PresheafOfModules` refers to the project-local `Scheme.PresheafOfModules`, NOT Mathlib's root namespace. When declaring Mathlib-shape lemmas, always use `_root_.PresheafOfModules`, `_root_.PresheafOfModules.Derivation`, `_root_.PresheafOfModules.comp_app`, etc. throughout.

### Pattern (NEW iter-081): `ext + simp only [postcomp_d_apply, comp_app] + rfl` recipe for Derivation composition

For `d.postcomp (f ≫ g) = (d.postcomp f).postcomp g` and similar Derivation-composition identities, the minimal proof is `ext X b; simp only [postcomp_d_apply, comp_app]; rfl`. The `rfl` step is essential: `simp only [ModuleCat.hom_comp]` does not fire on the residual `(f.app X ≫ g.app X).hom (...)` because the LHS does not present in the rewriter's expected shape, but `rfl` recovers — the underlying `LinearMap.comp` is defeq to the projected `.hom` composition.

### Anti-pattern (CONFIRMED iter-081): `Submodule.mem_top y` does not bridge forget₂-image module instances

When `y : M` where `M : ModuleCat ((R ⋙ forget₂ CommRingCat RingCat).obj U)`, the type-`R.obj U` `Module` instance on `M` exists (by forget₂-image transfer) but is NOT definitionally the one `Submodule.mem_top y` expects when invoked at type `M` viewed as a `Module (R.obj U)`. Both `change` to the `_root_.KaehlerDifferential _ _` view and direct `rw [← span_range_derivation]` fail at this point. The structural fix is to identify the descent map with `CommRingCat.KaehlerDifferential.map` (which has a known surjectivity-from-surjectivity lemma) before invoking surjectivity arguments.

---

## Blueprint markers updated (manual)

None this iter.

The blueprint chapter `Differentials.tex` already carries `\lean{PresheafOfModules.Derivation.postcomp_comp}` (Lemma `lem:derivation_postcomp_comp`) — the plan agent added that line in advance, and the underlying lemma landed fully closed in source this iter. The deterministic `sync_leanok` phase that ran between the prover and this review will have added `\leanok` to that block automatically; the review agent did NOT touch any `\leanok` markers.

No `\mathlibok` is appropriate for `Derivation.postcomp_comp` — it is a project-local Mathlib-shape lemma (one-line proof against project-local `Derivation` definitions), not a re-export of an existing Mathlib name.

`SheafOfModules.exact_iff_stalkwise` is still NOT introduced in source (the prover reverted it per conditional clause), so the blueprint chapter's `\lean{SheafOfModules.exact_iff_stalkwise}` macro continues to point at a non-existent declaration — `sync_leanok` will not have added `\leanok` to that block. No `% NOTE:` action needed: this is a planned helper, not a translation failure.

No `\notready` markers in active chapters this iter. No `\lean{...}` renames detected.

---

## Recommendations for next session

See `recommendations.md`.
