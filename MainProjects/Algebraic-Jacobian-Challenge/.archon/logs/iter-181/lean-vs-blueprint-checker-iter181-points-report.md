# Lean ↔ Blueprint Check Report

## Slug
iter181-points

## Iteration
181

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/Points.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`, L985)
- **Lean target exists**: yes (L120)
- **Signature matches**: yes — `𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`, i.e. a `k̄`-point of `ℙ¹` as a section. Matches the prose "morphism Spec k̄ → ℙ¹ in Over(Spec k̄)".
- **Proof follows sketch**: yes — uses `Proj.fromOfGlobalSections` via the private helper `pointOfVec`, exactly as the prose states ("defined via `Proj.fromOfGlobalSections`").
- **notes**: evaluation vector `(0, 1)` for `[0:1]`; unit-coordinate witness via `simp` on index `1`.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`, L999)
- **Lean target exists**: yes (L126)
- **Signature matches**: yes — same signature shape as `zeroPt`.
- **Proof follows sketch**: yes — `pointOfVec` of the constant-1 vector at index `0`.
- **notes**: matches prose.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`, L1011)
- **Lean target exists**: yes (L132)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `pointOfVec` of `(1, 0)` at index `0`.
- **notes**: prose note "second fixed point of the `𝔾_m`-scaling action" is corroborated by chapter narrative at L40–58.

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`, L949)
- **Lean target exists**: yes (L152) as `abbrev Ga ... : Over (Spec (.of kbar))`.
- **Signature matches**: yes — object of `Over (Spec (.of kbar))`, matching the prose "additive group object Ga = A¹ packaged as an object of Over(Spec k̄)".
- **Proof follows sketch**: N/A (definition).
- **notes**: underlying scheme `GaScheme := AffineSpace.{0,u} (Fin 1) (Spec ...)`; instances `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced` populate the "affine, locally of finite presentation, reduced" claims in the prose at L919/L937. Instance population is acceptable without per-instance pins.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`, L968)
- **Lean target exists**: yes (L196) as `abbrev Gm ... : Over (Spec (.of kbar))`.
- **Signature matches**: yes — encoded as the affine scheme `Spec (CommRingCat.of (GmRing kbar))` per the explicit `% NOTE (iter-172 encoding clarification)` at L957–964 of the chapter, which the Lean implementation realises exactly via `GmRing := Localization.Away (X () : MvPolynomial Unit kbar)` (L181) and `GmScheme := Spec (CommRingCat.of (GmRing kbar))` (L187).
- **Proof follows sketch**: N/A (definition).
- **notes**: the chapter's affine-vs-open-immersion clarification is faithfully realised; downstream consumers (the `W = Gm` slot in `lem:hom_additivity_over_product`) get an affine carrier as the prose requires.

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`, L1024)
- **Lean target exists**: yes (L514)
- **Signature matches**: yes — `𝟙_ (Over (Spec (.of kbar))) ⟶ Gm kbar`, defined as the group-object unit `η[Gm kbar]`. Matches prose: "supplied in Lean as the unit map η[Gm] : Spec k̄ → Gm".
- **Proof follows sketch**: N/A (definition).
- **notes**: definition depends on the `GrpObj Gm` instance at L502 (now resolved).

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`, L1037)
- **Lean target exists**: yes (L502) as `instance gm_grpObj ... : GrpObj (Gm kbar) := GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) (gmHomFunctor_representableBy kbar)`.
- **Signature matches**: yes — installs `GrpObj (Gm kbar)` in `Over (Spec (.of kbar))`, exactly the "multiplicative group-object structure (𝔾_m, ·, 1)" the prose asks for.
- **Proof follows sketch**: chapter is silent on the construction strategy (no `\begin{proof}` block for this definitional pin). The Lean realises it via `GrpObj.ofRepresentableBy` + a units-of-global-sections functor + an 8-step representable-by recipe (per the iter-179 `gm-grpobj-representable` analogy). The Lean docstring at L492–501 explains this; the blueprint does not preview it. Adequate for a *definitional* pin (the mathematical content "Gm is a group with `xy` multiplication and `1`" is unambiguous and well-known); the proof *strategy* is an implementation detail. See "Blueprint adequacy" below for whether a brief construction-route note in the chapter is worth adding.
- **notes**: this is the iter-181 closure of an 11-iter `gm_grpObj` STUCK pattern. No `sorry`, no axiom; transitively kernel-clean per the directive.

## Red flags

### Placeholder / suspect bodies
*(None.)*

### Excuse-comments
*(None substantive — see "Stale prose in docstring" below for one minor housekeeping item.)*

### Axioms / Classical.choice on non-trivial claims
*(None. The transitive axiom footprint reported in the directive is the kernel baseline `{propext, Classical.choice, Quot.sound}`.)*

### Stale prose in docstring (minor)
- `Points.lean:477-482`: the docstring on `gmHomFunctor_representableBy` describes the three round-trip / naturality lemmas as "named substantive sorries". As of iter-181 they are PROVEN substantive lemmas (`gmHomEquiv_left_inv`, `gmHomEquiv_right_inv`, `gmHomEquiv_homEquiv_comp`). This is **stale narrative**, not an excuse-comment for wrong code — the file genuinely has no sorries here — but the wording would mislead a reader checking iter-181 status. A 1-line refresh (e.g. "round-trip identities ... and naturality `homEquiv_comp` — all axiom-clean as of iter-181") would close the loop. Classified as **minor**, not must-fix, because the actual proofs are sound and the file compiles clean.

## Unreferenced declarations (informational)

The Lean file declares the following without a `\lean{...}` pin in the chapter. All are private helpers or non-pin-worthy instances — none flagged as needing promotion:

**Private helpers for the `ℙ¹` points:**
- `ProjectiveLineBar.evalIntoGlobal` (L51, private) — ring map builder
- `ProjectiveLineBar.irrelevant_map_eq_top` (L59, private) — unit-coordinate ⟹ irrelevant-ideal maps to ⊤
- `ProjectiveLineBar.pointOfVec` (L86, private) — common construction wrapped by `zeroPt`/`onePt`/`inftyPt`

**Private helpers for the `gm_grpObj` construction:**
- `gmHomFunctor` (L255, private) — the units-of-global-sections functor
- `gmHomEquiv_toFun` (L287, private) — forward of the per-`T` bijection
- `gmHomEquiv_invFun_isOver` (L298, private) — `Over`-commutativity lemma for `invFun`
- `gmHomEquiv_invFun` (L361, private) — backward of the per-`T` bijection
- `gmHomEquiv_left_inv` (L382, private) — round-trip 1
- `gmHomEquiv_right_inv` (L440, private) — round-trip 2
- `gmHomEquiv_homEquiv_comp` (L468, private) — naturality
- `gmHomFunctor_representableBy` (L483, private) — bundle into `RepresentableBy` witness

**Non-private underlying-data / instance helpers (acceptable as instance-level chapter prose, no individual pins needed):**
- `GaScheme` (L141, def) — underlying scheme of `Ga`; not pinned but `Ga` (the `Over`-packaged version) is pinned.
- `gaScheme_canOver`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced` (instances)
- `GmRing` (L180, abbrev) — `k̄[t, t⁻¹]` as a Type
- `GmScheme` (L186, def) — underlying scheme of `Gm`; not pinned but `Gm` is.
- `gmScheme_canOver`, `gm_isAffine`, `gm_locallyOfFinitePresentation`, `gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_smooth` (instances)

The chapter prose at L919–938 (the bundled `def:genus0_base_objects` block) and the per-decl `def:ga` / `def:gm` blocks describe the substance of these instances ("affine, of finite type, reduced; `ℙ¹` is proper; `Ga` and `Gm` are affine"). One-to-one instance pinning is not the project's convention here, and the math content is adequately conveyed.

## Blueprint adequacy for this file

- **Coverage**: 6/6 substantive (non-private, non-instance) Lean declarations have a `\lean{...}` pin in the chapter (`zeroPt`, `onePt`, `inftyPt`, `Ga`, `Gm`, `Gm.onePt`, `gm_grpObj` — counting `Ga`/`Gm`/`Gm.onePt`/`gm_grpObj`/`zeroPt`/`onePt`/`inftyPt`, all 7 are pinned). Unreferenced declarations: ~10 helpers (8 private + `GaScheme`/`GmScheme`/`GmRing` underlying-data) + ~11 instance declarations, all acceptable; 0 substantive non-helpers flagged.
- **Proof-sketch depth**: **adequate** for the definitional pins. The chapter is silent on the *internal* construction strategy of `gm_grpObj` (the 8-step representable-by recipe), but for a definitional pin (no `\begin{proof}` block) this is the project norm — the substantive content of "Gm is a group with multiplication and unit" is unambiguous textbook mathematics. The Lean file has good in-file docstrings explaining the strategy at L240–251 and L492–501. The choice to keep the construction off-chapter is defensible.
- **Hint precision**: **precise**. Every `\lean{...}` hint resolves to exactly the declared name, and the prose is unambiguous about what is being pinned (e.g. the explicit `% NOTE (iter-172 encoding clarification)` at L957–964 pins the affine `Spec(Localization.Away t)` encoding choice for `Gm` so a prover cannot accidentally implement the basic-open variant).
- **Generality**: **matches need**. The chapter scopes `𝔾_m`, `𝔾_a`, `ℙ¹` over `Spec k̄` with the right `Over`-packaging convention; the Lean realises the convention directly. No parallel API was needed to bridge a generality gap.
- **`% archon:covers` line at L3**: lists `AlgebraicJacobian/Genus0BaseObjects/Points.lean` (verified). ✓
- **Recommended chapter-side actions**:
  - *Optional (minor)*: the `def:gm_grpObj` block at L1034–1047 could append a sentence noting that Lean realises the instance via `GrpObj.ofRepresentableBy` against a units-of-global-sections functor `T ↦ Γ(T.left, ⊤)ˣ` (Mathlib's `IsLocalization.Away`-Spec bijection). This would mirror the level of internal-construction transparency already present in some other definition blocks (e.g. `def:proj_chart_ring_iso` references its Mathlib-side anchor explicitly). Not required by the gate.
  - *Recommended (minor)*: stale-docstring refresh on `gmHomFunctor_representableBy` (Lean L477–482) — drop the "named substantive sorries" phrasing now that all three are closed. (This is a Lean-side action, not a blueprint one, but listed here for the dispatcher to route.)
  - **No must-fix-this-iter chapter actions.**

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  1. Stale narrative in the `gmHomFunctor_representableBy` docstring (Lean L477–482) — describes the three closed lemmas as "named substantive sorries". Refresh recommended.
  2. Optional chapter expansion: `def:gm_grpObj` could note the `ofRepresentableBy` construction route (parity with other definition blocks). Not required.

**Overall verdict**: PASS the HARD GATE on both `complete:` and `correct:` axes — the iter-181 closure of `gm_grpObj` is faithfully reflected in a sound Lean instance with a precisely-pinned chapter block, no sorries / axioms / excuse-comments, and only minor stale-docstring / chapter-expansion housekeeping outstanding.
