# Lean ↔ Blueprint Check Report

## Slug
fbc039

## Iteration
039

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Summary of this-iter changes verified

Two declarations were added and proved axiom-clean this iteration:
- `base_change_mate_reindex_conj_pullbackLeg` (conj-2b, Lean line ~1625)
- `base_change_mate_reindex_conj_crossLayer` (conj-2d, Lean line ~1652)

The crux `base_change_mate_fstar_reindex_legs_conj` (line ~1757) retains `sorry` at line 1822.
`base_change_mate_gstar_transpose` (line ~2164) retains `sorry` at line 2289.
Two unrelated affine-reduction sorries remain at lines 2470 and 2492.

---

## Per-declaration

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pullbackLeg}` (chapter: `lem:base_change_mate_reindex_conj_pullbackLeg`, conj-2b)
- **Lean target exists**: yes (line 1625)
- **Signature matches**: yes — Lean theorem has exact type matching the blueprint's description: the conjugate of `leftAdjointCompIso(pushforwardComp f g).inv` equals `(pushforwardComp f g).hom`; blueprint prose matches
- **Proof follows sketch**: yes — one-line proof `Adjunction.conjugateEquiv_leftAdjointCompIso_inv _ _ _ _`, axiom-clean; matches the blueprint's "direct application of the cited conjugation identity"
- **`\leanok` marker**: statement-block `\leanok` present at blueprint line 2124 ✓; no proof-block `\leanok` (project convention: only statement-block markers); given the proof is axiom-clean this is a sync artifact but not an error
- **notes**: matches cleanly

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_crossLayer}` (chapter: `lem:base_change_mate_reindex_conj_crossLayer`, conj-2d)
- **Lean target exists**: yes (line 1652)
- **Signature matches**: yes — Lean theorem states the general-ψ unit transport (from the geometric `(Spec ψ)`-unit through the pushforward Γ-comparison to the algebraic extend/restrict-scalars unit); blueprint description matches
- **Proof follows sketch**: yes — proof (lines 1652–1724) implements the transposed unit-across-conjugate coherence (`unit_conjugateEquiv_symm`) route described in the blueprint; large proof (~70 LOC) but all terms match the blueprint's strategy; axiom-clean
- **`\leanok` marker**: statement-block `\leanok` present at blueprint line 2180 ✓
- **notes**: matches cleanly; the proof is a significant development (the general-ψ port of Seam-1, as documented)

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj}` (chapter: `lem:base_change_mate_fstar_reindex_legs_conj`, conj-2a — the crux)
- **Lean target exists**: yes (line 1757)
- **Signature matches**: yes — Lean signature matches the blueprint's description of the leg-reindex coherence on the conjugate side
- **Proof follows sketch**: partial — after `rw [base_change_mate_codomain_read_legs_conj]` (line 1815) a single `sorry` remains (line 1822); blueprint proof strategy is correctly implemented up to this point; the remaining step (recognising the composite as a `conjugateEquiv` value) is described in blueprint and in the Lean comment, but is unresolved
- **`\leanok` marker**: statement-block `\leanok` present at blueprint line 2215 ✓ (declaration exists with sorry); no proof-block `\leanok` ✓ (proof not closed); honesty maintained
- **notes**: See Red Flags section — the NOTE comment inside the blueprint block is stale

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (chapter: `lem:base_change_mate_gstar_transpose`)
- **Lean target exists**: yes (line 2164)
- **Signature matches**: yes — Lean signature matches the blueprint description of the `(g^* ⊣ g_*)` transpose crux
- **Proof follows sketch**: partial — `huce` infrastructure (counit split, conjugate-counit identity) is built and compiling; single `sorry` at line 2289 for the remaining ~150-LOC telescoping (steps a/b/c); blueprint accurately describes what remains
- **`\leanok` marker**: statement-block `\leanok` present at blueprint line 2985 ✓; no proof-block `\leanok` ✓; honesty maintained
- **notes**: gated behind the `_legs_conj` crux as expected

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 2439)
- **Signature matches**: yes
- **Proof follows sketch**: partial — `sorry` at line 2470 for the affine-reduction step (restriction-compatibility of `pushforwardBaseChangeMap`, Mathlib-absent); blueprint is honest about this gap in its NOTE
- **`\leanok` marker**: statement-block `\leanok` at blueprint line 3380 ✓; no proof-block ✓

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 2479)
- **Signature matches**: yes
- **Proof follows sketch**: partial — `sorry` at line 2492; blueprint is honest (multi-step Čech infrastructure missing)
- **`\leanok` marker**: statement-block `\leanok` at blueprint line 3824 ✓; no proof-block ✓

---

## Red Flags

### Stale NOTE comment (major)

**Blueprint, `lem:base_change_mate_fstar_reindex_legs_conj`, lines 2219–2227** contains a `% NOTE` comment dated iter-036 which states:

> "conj-2b (lem:..._pullbackLeg) and conj-2d (lem:..._crossLayer) are not typed in Lean."

This is **factually incorrect as of iter-039**: both conj-2b (`base_change_mate_reindex_conj_pullbackLeg`) and conj-2d (`base_change_mate_reindex_conj_crossLayer`) are now typed in Lean AND proved axiom-clean. A plan agent reading the blueprint would be misled by this claim about the current state of conj-2b and conj-2d.

The same NOTE says the `_legs_conj` node "is no longer on the route to closing `gstar_transpose`; it is cleanup debt to prune once `gstar_transpose` lands." However, the Lean comment at lines 1808–1814 confirms all three legs (conj-2b, conj-2c, conj-2d) are now built and axiom-clean, and the remaining bottleneck is the conjugate-reframing keystone. The question of whether `_legs_conj` feeds `gstar_transpose` indirectly should be clarified (the Lean comment at line 2276–2278 says `gstar_transpose` reprovides the inner value inline, bypassing `_legs`). The NOTE is outdated in either case.

**Recommended fix**: Update the NOTE to reflect the iter-039 state: conj-2b and conj-2d are proved axiom-clean, and the single remaining obligation for `_legs_conj` is the conjugate-reframing keystone.

### Placeholder bodies (informational, not a new red flag)

The following `sorry`s are expected and tracked:
- Line 1822 (`base_change_mate_fstar_reindex_legs_conj`): crux, open by design
- Line 2289 (`base_change_mate_gstar_transpose`): gated, open by design  
- Line 2470 (`affineBaseChange_pushforward_iso`): affine-reduction step, separate obligation
- Line 2492 (`flatBaseChange_pushforward_isIso`): Čech infrastructure, deferred

All four are reflected honestly in the blueprint (statement-block `\leanok`, no proof-block `\leanok`), and the Lean docstrings explicitly note which sorries are "transitively sorry-backed." No misrepresentation.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file without a direct `\lean{...}` blueprint reference (they are helpers or bundled sub-results):
- `base_change_mate_reindex_conj_pushforwardCollapse` (line ~1736): **IS** referenced at `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pushforwardCollapse}` (blueprint line 2157) ✓ — conj-2c
- Various `conjPullbackFactor`, section-level helpers: internal plumbing, acceptable as blueprint-unreferenced

No substantive Lean declaration appears to lack a blueprint reference that it should have.

---

## Blueprint adequacy for this file

- **Coverage**: All three this-iter declarations (conj-2b, conj-2d, and the crux conj-2a) have corresponding `\lean{...}` blocks. The wider file coverage is also complete for the main declarations. **No gap here.**

- **Proof-sketch depth for `_legs_conj`**: **under-specified at the keystone step.** The blueprint proof sketch (lines 2246–2264) correctly identifies the strategy: (1) apply `conjugateEquiv.injective`, (2) lift locked components by surjectivity, (3) close by conj-2b/2c/2d. However, it does not specify:
  - The concrete `adjL`/`adjR` adjunctions and base object `c` to use when reframing the LHS as a `conjugateEquiv adjL adjR` value
  - How to express the large section-level composite `gammaPushforwardTildeIso.inv ≫ moduleSpecΓFunctor.map(…) ≫ (gammaPushforwardIso ψ … ≪≫ restrictScalars ψ .mapIso(…)).hom` as a single `conjugateEquiv` application, so `.injective` is applicable
  
  This gap is the precise obstruction identified in the Lean comment (lines 1816–1821). The blueprint describes WHAT to do but not HOW to set up the typing argument that the composite is literally a `conjugateEquiv` value. A blueprint-writing subagent should add a `% NOTE:` annotation giving the concrete `adjL`/`adjR` and the structural identification argument (e.g., noting that this composite is `(conjugateEquiv adjL adjR).toEquiv.symm applied to ...`).

- **Hint precision**: precise — `\lean{...}` names match actual Lean identifiers throughout

- **Generality**: matches need

- **Recommended chapter-side actions**:
  1. **Update the stale NOTE** in `lem:base_change_mate_fstar_reindex_legs_conj` (lines 2219–2227) to reflect that conj-2b and conj-2d are now proved axiom-clean as of iter-039
  2. **Add a `% NOTE:`** to the `lem:base_change_mate_fstar_reindex_legs_conj` proof block pinning the concrete `adjL`, `adjR`, and the structural argument for why the LHS is a `conjugateEquiv` value — this is the specific under-specification the prover needs to close the keystone

---

## Severity summary

- **must-fix-this-iter**: none — no wrong Lean signatures, no fake proved statements, no axioms on substantive claims

- **major** (1): Stale `% NOTE` comment in `lem:base_change_mate_fstar_reindex_legs_conj` (lines 2219–2227) asserts conj-2b and conj-2d "are not typed in Lean" — factually incorrect post-iter-039. Could mislead the plan agent about what remains to be done. Fix: update NOTE to reflect current state.

- **minor** (1): Blueprint proof sketch for `_legs_conj` under-specifies the `conjugateEquiv`-reframing keystone — doesn't pin the concrete `adjL`/`adjR`/object that would make `.injective` directly applicable to the LHS. The Lean engineer must independently discover this; providing it in a `% NOTE:` would directly unblock the crux.

**Overall verdict**: conj-2b and conj-2d are correctly represented in the blueprint and proved axiom-clean in Lean; `_legs_conj` and `gstar_transpose` are honestly marked as open; the single actionable issue is the stale NOTE comment in `_legs_conj` misrepresenting the current Lean state of conj-2b/2d. 6 declarations checked (conj-2b, conj-2d, conj-2a/_legs_conj, gstar_transpose, affineBaseChange, flatBaseChange), 1 major red flag (stale NOTE).
