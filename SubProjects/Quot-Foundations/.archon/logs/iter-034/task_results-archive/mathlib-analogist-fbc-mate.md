# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
fbc-mate

## Iteration
034

## Structural problem
Show the affine flat-base-change comparison `g^* f_* F ⟶ f'_* g'^* F` (Stacks 02KH part 2, i = 0) is
an iso and prove the sheaf-level coherence (`base_change_mate_fstar_reindex_legs`) transporting the
already-proven module iso up to the sheaf level. Abstract shape: the mate / conjugate (Beck–Chevalley
2-cell) of a pasted square of two **composite** adjunctions `adjL = (tilde ⊣ Γ)_R ∘ (g^* ⊣ g_*)`,
`adjR = (extend ⊣ restrict)_ψ ∘ (tilde ⊣ Γ)_{R'}`, related by `β = gammaPushforwardNatIso ψ`. The
crux is being fought as a positional equation under the `X.Modules` instance diamond, where every keyed
tactic is dead and term-mode splicing bottoms out at cross-layer naturality of `gammaPushforwardIso ψ`.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `CompositionIso.lean`: `leftAdjointCompIso` (72), `conjugateEquiv_leftAdjointCompIso_inv` (82), `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` (140), `leftAdjointCompNatTrans_assoc` (155) | composite-adjunction conjugate calculus | medium | ANALOGUE_FOUND |
| `Mates.lean`: `unit_conjugateEquiv_symm` (305), `conjugateEquiv_counit_symm` (287), `conjugateEquiv_comp`/`_symm_comp` (337/354) + `Adjunction.comp_unit_app`/`comp_counit_app` | conjugate component calculus (Seam 1/3 tools) | low | ANALOGUE_FOUND |
| `Mates.lean`: `iterated_mateEquiv_conjugateEquiv` (450), `conjugateIsoEquiv` (412), `conjugateEquiv_iso`/`_symm_iso`/`_of_iso`/`_symm_of_iso` (380/388/396/405) | mate / Beck–Chevalley calculus | low (mostly done) | PARTIAL_ANALOGUE |

## Direct answers to the directive's questions

**Q1a — "mate of a pasted square = paste of the mates"?** YES, exact declarations (pinned Mathlib,
`Mathlib/CategoryTheory/Adjunction/Mates.lean`):
- `mateEquiv_vcomp` (line 167): `(mateEquiv adj₁ adj₃) (α ≫ₕ β) = (mateEquiv adj₁ adj₂ α) ≫ᵥ (mateEquiv adj₂ adj₃ β)`.
- `mateEquiv_hcomp` (line 206): `(mateEquiv (adj₁.comp adj₃) (adj₂.comp adj₄)) (α ≫ᵥ β) = (mateEquiv adj₃ adj₄ β) ≫ₕ (mateEquiv adj₁ adj₂ α)` — **the composite-adjunction case**.
- `mateEquiv_square` (line 242): mate of a 2×2 grid of squares = composite of the four mates. Literally "the mate of a pasted square is the paste of the mates."
- Conjugate-side fusion: `conjugateEquiv_comp` (337, `@[reassoc (attr := simp)]`),
  `conjugateEquiv_symm_comp` (354, same attr).

**Q1b — "IsIso-of-mate from IsIso-of-2-cell"?**
- For the **general `mateEquiv`: NO** — Mathlib states explicitly (Mates.lean:79, :269) that a general
  mate does not inherit iso-ness.
- For **`conjugateEquiv` (vertical functors `𝟭`): YES** — `conjugateEquiv_iso` (instance, 380),
  `conjugateEquiv_symm_iso` (instance, 388), converses `conjugateEquiv_of_iso` (396) /
  `conjugateEquiv_symm_of_iso` (405), packaged as `conjugateIsoEquiv` (412).
- Signatures:
  ```
  instance conjugateEquiv_iso {C D} [Category C] [Category D] {L₁ L₂ : C ⥤ D} {R₁ R₂ : D ⥤ C}
      (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : L₂ ⟶ L₁) [IsIso α] : IsIso (conjugateEquiv adj₁ adj₂ α)
  instance conjugateEquiv_symm_iso (… same …) (α : R₁ ⟶ R₂) [IsIso α] :
      IsIso ((conjugateEquiv adj₁ adj₂).symm α)
  def conjugateIsoEquiv (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) : (L₂ ≅ L₁) ≃ (R₁ ≅ R₂)
  ```

**Q2 — Beck–Chevalley / base-change package?** **No standalone `BeckChevalley` namespace exists**
(grep over Mathlib is empty). The phenomenon is a single theorem:
```
theorem iterated_mateEquiv_conjugateEquiv {A B C D} […] {F₁ U₁ F₂ U₂ L₁ R₁ L₂ R₂}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (adj₃ : F₁ ⊣ U₁) (adj₄ : F₂ ⊣ U₂)
    (α : TwoSquare F₁ L₁ L₂ F₂) :
  (mateEquiv adj₄ adj₃ (mateEquiv adj₁ adj₂ α)).natTrans
    = conjugateEquiv (adj₁.comp adj₄) (adj₃.comp adj₂) α            -- Mates.lean:450
```
Its docstring: "When all four functors in a square are left adjoints … the iterated mate equals the
conjugate of the original transformation and is thus an isomorphism if and only if the original
transformation is. This explains why some Beck-Chevalley natural transformations are natural
isomorphisms." The project's square (top/bottom `g^*`/`g'^*`, verticals `tilde`/`tilde`, all left
adjoints) qualifies; combined with `conjugateEquiv_iso` this is Mathlib's complete Beck–Chevalley
iso package. (`Bicategory/Adjunction/Mate.lean` has a bicategorical mate calculus but no 1-cat
base-change package beyond the above.)

## Key clarification on the project's actual state
Iso-ness (directive goal (i)) is **already free** in the project: `pullback_spec_tilde_iso`
(FlatBaseChange.lean:696) is `conjugateIsoEquiv adjL adjR` of `gammaPushforwardNatIso`, an iso of an
iso. The genuinely open obstacle is the **coherence** `base_change_mate_fstar_reindex_legs` (ii), not
iso-ness. So the win is not a new IsIso lemma — it is re-expressing the coherence as a `conjugateEquiv`
component identity so it never becomes a positional rewrite under the diamond.

## Top suggestion
Re-encode the comparison object and prove `_legs` on the conjugate side. (1) Rebuild
`base_change_mate_codomain_read_legs` proof-free from `Scheme.Modules.leftAdjointCompIso` /
`pullbackComp` / `pushforwardComp` of the **free** morphisms `e.hom`, `Spec.map inclA` (square via
`pushforwardCongr comm`), carrying no `hfst/hsnd`. (2) Restate `base_change_mate_fstar_reindex_legs` at
the explicit composite `e.hom ≫ Spec.map inclA`. (3) Discharge by
`apply (Scheme.Modules.conjugateEquiv …).injective` (template:
`leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm`, CompositionIso.lean:140 — `obtain ⟨_, rfl⟩ :=
(conjugateEquiv …).surjective` → `apply (conjugateEquiv …).injective` → `simp` with the reassoc
conjugate set), closing with `conjugateEquiv_pullbackComp_inv` (project Sheaf.lean:238) +
`conjugateEquiv_comp`/`_symm_comp`/`_whiskerLeft`/`_whiskerRight`/`_associator_hom` (Mates.lean
337/354/525/536/501) + the project's `gammaMap_pushforwardComp_*` collapses; the cross-layer
`gammaPushforwardIso ψ` naturality enters as `unit_conjugateEquiv_symm` (Mates.lean:305) +
`conjugateEquiv_comp` — Seam 1's tool, one functor layer up, with the "through `(Spec φ)_*`" transport
realised as a `conjugateEquiv_comp` (because `(Spec φ)_*` is the right adjoint of `(Spec φ)^*`), never
a positional `rw`. First Mathlib read: `CompositionIso.lean:63–179`. First project edit:
`FlatBaseChange.lean` `base_change_mate_codomain_read_legs` (~1210) and
`base_change_mate_fstar_reindex_legs` (1381–1495).

## Discarded
- General `mateEquiv` IsIso transfer: rejected — Mathlib explicitly denies it (Mates.lean:79/:269);
  only the conjugate specialisation transfers isos.
- `iterated_mateEquiv_conjugateEquiv` as the *primary* fix: it certifies iso-ness, which the project
  already has; it does not by itself close the (ii) coherence. Kept as PARTIAL_ANALOGUE /
  documentation that the project's `conjugateIsoEquiv` encoding is the canonical Beck–Chevalley one.

## Persistent file
- `analogies/fbc-mate-reencode.md` — analogue list + port sketch captured for future iters.

Overall verdict: Mathlib's mate/conjugate API is sufficient — the composite-square mate is fully
expressible (`mateEquiv_hcomp`/`_square`, `iterated_mateEquiv_conjugateEquiv`, conjugate-iso
instances); the project's only task is re-encoding `_legs` as a `conjugateEquiv`-component identity via
`leftAdjointCompIso` + the `.injective`/reassoc-conjugate idiom, so the `X.Modules` diamond never forms.
