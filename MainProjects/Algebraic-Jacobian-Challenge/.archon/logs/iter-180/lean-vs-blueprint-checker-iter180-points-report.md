# Lean ↔ Blueprint Check Report

## Slug
iter180-points

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/Points.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`, L949)
- **Lean target exists**: yes — `Ga` at `Points.lean:152` (abbrev).
- **Signature matches**: yes — `(kbar : Type u) [Field kbar] : Over (Spec (.of kbar))` matches the chapter's "packaged as an object of `Over (Spec k̄)`".
- **Proof follows sketch**: N/A (definition, not a proof).
- **notes**: body `(GaScheme kbar).asOver (Spec (.of kbar))` aligns with the chapter's `AffineSpace (Fin 1) (Spec k̄)` reading.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`, L968)
- **Lean target exists**: yes — `Gm` at `Points.lean:196` (abbrev).
- **Signature matches**: yes — `(kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`.
- **Proof follows sketch**: N/A (definition).
- **notes**: chapter explicitly authorises the affine `Spec (Localization.Away t)` encoding (L975–979); Lean realises it via `GmScheme := Spec (CommRingCat.of (GmRing kbar))` with `GmRing := Localization.Away (X () : MvPolynomial Unit kbar)`. Faithful.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`, L985)
- **Lean target exists**: yes — `ProjectiveLineBar.zeroPt` at `Points.lean:120`.
- **Signature matches**: yes — `: 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`.
- **Proof follows sketch**: yes — built via `pointOfVec` (i.e. `Proj.fromOfGlobalSections`) with evaluation `X₀ ↦ 0, X₁ ↦ 1`, matching the chapter's prose "via `Proj.fromOfGlobalSections`".
- **notes**: chapter calls out the `(0, ∞)` fixed-point role; Lean encodes correctly.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`, L999)
- **Lean target exists**: yes — `ProjectiveLineBar.onePt` at `Points.lean:126`.
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `pointOfVec kbar (fun _ => 1) 0 (by simp)`.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`, L1011)
- **Lean target exists**: yes — `ProjectiveLineBar.inftyPt` at `Points.lean:132`.
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `pointOfVec kbar (fun i => if i = 0 then 1 else 0) 0 (by simp)`.

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`, L1024)
- **Lean target exists**: yes — `Gm.onePt` at `Points.lean:470`.
- **Signature matches**: yes — `: 𝟙_ (Over (Spec (.of kbar))) ⟶ Gm kbar`.
- **Proof follows sketch**: yes — body is `η[Gm kbar]`, the group-object unit, matching the chapter's "unit map η[Gm] : Spec k̄ → Gm".

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`, L1037)
- **Lean target exists**: yes — `gm_grpObj` at `Points.lean:458` (instance).
- **Signature matches**: yes — `(kbar : Type u) [Field kbar] : GrpObj (Gm kbar)` (LSP hover confirms).
- **Proof follows sketch**: PARTIAL — body is `GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) (gmHomFunctor_representableBy kbar)`, the canonical Mathlib idiom from `analogies/gm-grpobj-representable.md` Decision 1. The `representableBy` witness, however, transitively carries two `sorry`s through the helpers `gmHomEquiv_left_inv` and `gmHomEquiv_right_inv` (round-trip identities). The chapter's prose says nothing about this route, so this is "PARTIAL by silence" rather than "PARTIAL by divergence" — see the blueprint-adequacy section.
- **notes**: no `\leanok` is on this block (the deterministic sync will reflect that the body still propagates `sorry`).

## Red flags

### Placeholder / suspect bodies
- `Points.lean:382` (`gmHomEquiv_left_inv`): body is `:= sorry` after `intro f; apply Over.OverMorphism.ext`. Substantive round-trip identity feeding `gm_grpObj`. The Lean docstring honestly flags it (no excuse-comment) and sketches the iter-181 attack (Γ-Spec adjunction injectivity + `IsLocalization.Away.lift` uniqueness on generators).
- `Points.lean:400` (`gmHomEquiv_right_inv`): body is `:= sorry` after `intro u; apply Units.ext; change …`. Substantive identity. Honestly flagged; the docstring identifies the specific Mathlib-API blocker (`rw [← Scheme.ΓSpecIso_inv_naturality_assoc]` metavariable unification failure) and the planned manual `congr` / `Iso.inv_comp_eq` workaround.

Both sorries are on **private helpers**, not directly on a `\lean{...}`-pinned declaration. They propagate `sorryAx` into the pinned `gm_grpObj`, whose own body is a genuine expression (not `:= sorry`). Strictly read, the must-fix rule for "placeholder body on a declaration the blueprint claims is substantive" applies only to the pinned target — `gm_grpObj`'s body is not a placeholder, and the chapter has no `\leanok` claim on it. The sorries are real but documented and scoped to scaffolding for iter-181, not weakened-wrong definitions or laundering attempts.

### Excuse-comments
- None. The two sorry-carrying docstrings are diagnostic ("BLOCKER: …", "iter-181+ work to land …"), not excuse-comments — they record the specific Mathlib-API obstruction and the planned next step. Acceptable per the report rules.

### Axioms / Classical.choice on non-trivial claims
- None. No `axiom` declarations; no suspect `Classical.choice _` patterns.

## Unreferenced declarations (informational)

All unpinned declarations are either:
- **Private helpers for pinned definitions** (acceptable):
  `evalIntoGlobal`, `irrelevant_map_eq_top`, `pointOfVec` (feeding `zeroPt`/`onePt`/`inftyPt`); `gmHomFunctor`, `gmHomEquiv_toFun`, `gmHomEquiv_invFun_isOver`, `gmHomEquiv_invFun`, `gmHomEquiv_left_inv`, `gmHomEquiv_right_inv`, `gmHomEquiv_homEquiv_comp`, `gmHomFunctor_representableBy` (feeding `gm_grpObj`).
- **Scheme-level shims and free instances**:
  `GaScheme`, `gaScheme_canOver`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced`; `GmRing`, `GmScheme`, `gmScheme_canOver`, `gm_isAffine`, `gm_locallyOfFinitePresentation`, `gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_smooth`.

  These are not pinned individually in the chapter. The umbrella `def:genus0_base_objects` (L912) prose says "all three are of finite type over `\bar k`; `\mathbb P^1` is proper, while `\mathbb G_a` and `\mathbb G_m` are affine"; these instance-level facts are the formal realisation of that prose. Acceptable as helpers.

  Worth noting: `gm_smooth` (L463) carries `[IsAlgClosed kbar]` and discharges to `smooth_of_grpObj_of_isAlgClosed`; the chapter mentions smoothness in the chain prose but does not pin this instance per-decl. Pinning it as a sibling `\lean{...}` block under `def:gm` would be defensible (minor); not blocking.

## Blueprint adequacy for this file

- **Coverage**: 7/7 pinned declarations land cleanly (`Ga`, `Gm`, `zeroPt`, `onePt`, `inftyPt`, `Gm.onePt`, `gm_grpObj`). 22 unpinned declarations, all classifiable as helpers or free-instance shims (no substantive unreferenced declaration).
- **Proof-sketch depth**: **under-specified** for `def:gm_grpObj` (L1034–1047). The chapter block describes the result ("the multiplicative group-object structure, multiplication and unit, consumed only as carrier for `\sigma_\times`") but is **entirely silent on the formalisation route**: no mention of Yoneda, no mention of `GrpObj.ofRepresentableBy`, no mention of the units-of-global-sections functor, no preview of the 3-step bijection (over-cat unfold → Γ⊣Spec adjunction → `IsLocalization.Away.lift`), no mention that the round-trip identities will need separate sub-lemmas. The recipe lives in `analogies/gm-grpobj-representable.md` (Decision 3, the 8-step recipe + closing-skeleton). A prover dispatched against the blueprint **alone** would not have any of this; it depends on the analogy being in scope.

  Adequacy elsewhere is fine: `def:p1bar_zero`, `def:p1bar_one`, `def:p1bar_infty` correctly name `Proj.fromOfGlobalSections` as the construction; `def:gm` flags the affine-Spec encoding choice; `def:ga` is essentially trivial.

- **Hint precision**: precise. All 7 `\lean{...}` slugs resolve to declarations with matching signatures.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  - Extend `def:gm_grpObj` (L1041–1046) with a short "Formalisation note" paragraph previewing the route: name `GrpObj.ofRepresentableBy`, the units-of-global-sections functor `T ↦ Γ(T.left, ⊤)ˣ`, the 3-step bijection (over-cat unfold + Γ⊣Spec adjunction + `IsLocalization.Away.lift`), and the round-trip-identity / naturality decomposition. Cross-reference `analogies/gm-grpobj-representable.md` for the canonical idiom. (~10 prose lines.)
  - Optionally pin a per-decl `\lean{AlgebraicGeometry.gm_smooth}` block under `def:gm` so the smoothness consumer is statically linkable. (Minor; not blocking.)

## Severity summary

- **must-fix-this-iter**: none. (The 2 `sorry`s are on private scaffolding helpers, not on the pinned `gm_grpObj` declaration; the chapter does not `\leanok` `gm_grpObj`; no excuse-comments; no unauthorised axioms; no weakened-wrong definitions; all 7 pinned signatures match the prose.)
- **major**: 1 — `def:gm_grpObj` is **under-specified** as a guide for iter-181. The blueprint should preview the Yoneda + `ofRepresentableBy` route and cross-reference `analogies/gm-grpobj-representable.md`. Without that, a prover working from prose-only could not formalise the body of `gm_grpObj` correctly; the formalisation route survives only because the analogy file is in the project artefact set, which is a fragile dependency.
- **minor**: 1 — `gm_smooth` (L463) is a substantive instance worth a per-decl `\lean{...}` pin under `def:gm` (formalisation infrastructure, not on the genus-0 critical path).

Overall verdict: signatures and proof-bodies of all 7 pinned declarations are faithful to the chapter; the only real gap is a blueprint-adequacy one — `def:gm_grpObj` needs a formalisation-route paragraph (Yoneda + `ofRepresentableBy` + cross-reference to `analogies/gm-grpobj-representable.md`) so the iter-181 closure of the 2 round-trip-identity sorries is guided by the chapter, not solely by the analogy file.
