# Lean Audit Report — iter-054

**Auditor:** lean-auditor subagent  
**Date:** 2026-06-10  
**Scope:** All `.lean` files under `AlgebraicJacobian/`; extra attention to
`FlatteningStratification.lean` and `GrassmannianQuot.lean` (modified this iter).

---

## Per-file checklist

### 1. `AlgebraicJacobian.lean` (9 lines)
- **Code sorries:** 0
- **Axiom cleanliness:** N/A (import-only)
- **Stale/excuse comments:** none
- **Verdict:** Clean.

---

### 2. `Cohomology/RegroupHelper.lean` (99 lines)
- **Code sorries:** 0
- **Axiom cleanliness:** clean — `base_change_regroup_linearEquiv` has a real body
- **Stale/excuse comments:** none
- **Verdict:** Clean.

---

### 3. `Cohomology/FlatBaseChangeGlobal.lean` (251 lines)
- **Code sorries:** 0
- **Axiom cleanliness:** clean — all three declarations (`exists_finite_affineCover_inter_isQuasiCompact`,
  `Modules.gammaIsLimitSheafConditionFork`,
  `Modules.exists_finite_affineCover_isLimit_sheafConditionFork`) have real bodies
- **Stale/excuse comments:** none
- **Verdict:** Clean.

---

### 4. `Picard/RelativeSpec.lean` (293 lines)
- **Code sorries:** 0 (all 3 occurrences of "sorry" are in comment text only)
- **Axiom cleanliness:** clean — `QcohAlgebra`, `RelativeSpec`, `structureMorphism` all have real bodies
- **Stale/excuse comments:** none; comment history mentioning prior iter-176/177 corrections is factual
- **Verdict:** Clean.

---

### 5. `Picard/GradedHilbertSerre.lean`
- **Code sorries:** 0
- **Axiom cleanliness:** clean — `coeff_invOneSubPow_one_mul`, `rationalHilbert_antidiff` and
  supporting lemmas all have real bodies
- **Stale/excuse comments:** none
- **Verdict:** Clean.

---

### 6. `Picard/SectionGradedRing.lean`
- **Code sorries:** 0 (1 "sorry" occurrence is in a comment at line 431)
- **Axiom cleanliness:** clean — tensor product infrastructure for sheaves of modules, all real bodies
- **Stale/excuse comments:** none
- **Verdict:** Clean.

---

### 7. `Picard/GrassmannianCells.lean` (2045 lines)
- **Code sorries:** 0
- **Axiom cleanliness:** clean — `affineChart`, `universalMatrix`, `minorDet`, `universalMinor`,
  transition maps, separatedness, properness (E1–E5), `isProper` all axiom-clean
- **Stale/excuse comments:** none; section headings use "scaffold" keyword for the
  no-op filter but this is organisational, not an excuse-comment
- **Suspect defs:** none
- **Verdict:** Clean. Fully closed geometric Grassmannian construction.

---

### 8. `Picard/QuotScheme.lean` (2776 lines)
- **Code sorries:** 4
  - Line 126: `hilbertPolynomial` — typed `sorry` body; blueprint-pinned, "iter-177+ body" documented
  - Line 165: `QuotFunctor` — typed `sorry` body; same documentation
  - Line 201: `Grassmannian` — typed `sorry` body; same documentation  
  - Line 228: `Grassmannian.representable` — typed `sorry` body; same documentation
- **Honest vs laundered:** All four are honest file-skeleton sorries; the surrounding support
  infrastructure (hundreds of lines of gap1/gap2 keystone machinery) is axiom-clean
- **Axiom cleanliness:** all non-sorry decls appear axiom-clean
- **Stale/excuse comments:** The TODO mention at line 758 ("fills the `Mathlib/Topology/Sheaves/Over.lean` TODO")
  is a factual remark, not an excuse-comment
- **Verdict:** Four open file-skeleton targets, all correctly acknowledged. No concerns.

---

### 9. `Picard/GrassmannianQuot.lean` (607 lines) — **modified this iter**
- **Code sorries:** 6
  - Line 271: `glue` (module descent over `GlueData`) — `sorry` body; "NOTE (scaffold): body to be
    filled; cocycle conditions recorded in signature"
  - Line 347: `universalQuotient` — `sorry` body; "NOTE (scaffold): rides on `Scheme.Modules.glue`"
  - Line 356: `tautologicalQuotient` — same scaffold pattern; depends on `glue`
  - Line 524: `pullbackObjUnitToUnit_comp` — labeled "PARTIAL" in docstring; `sorry` after
    `comp_homEquiv` factoring; genuine obstruction documented (conjugate coherence
    `conjugateEquiv_pullbackComp_inv` + whnf timeout on `pullbackComp` unfolding)
  - Line 595: `functor.map_comp` sub-goal — `sorry` for composite-free coherence analogue;
    depends on `pullbackObjUnitToUnit_comp`
  - Line 605: `represents` — `sorry` body; "NOTE (scaffold): body to be filled once `functor`,
    `tautologicalQuotient`, and `Scheme.Modules.glue` land"
- **Dependency structure:** `glue` (line 271) is the gating sorry; three other sorries
  (`universalQuotient`, `tautologicalQuotient`, `represents`) are direct scaffolds waiting on it.
  `pullbackObjUnitToUnit_comp` (line 524) is a separate blocker gating `functor.map_comp` (line 595).
- **Honest vs laundered:** All 6 are honest. The "NOTE (scaffold)" docstring pattern is close to
  excuse-comment territory per auditor standards but is not hiding wrong code — the accompanying
  signatures correctly record the cocycle/coherence obligations.
- **Axiom cleanliness of new decls this iter:** `pullbackBaseChangeTransport`,
  `glueData_bridge_src/mid/tgt`, `opensMap_final`, `pullbackFreeIso`,
  `pullback_isLocallyFreeOfRank`, `RankQuotient` structure, `rqPullback`, `rqPullback_rel`,
  `pullbackObjUnitToUnit_id`, `pullbackFreeIso_id`, `functor.map_id` — all appear axiom-clean
- **Suspect defs / bad practice:** The `rqPullback.epi` proof (lines 424–429) uses fully-explicit
  `@`-instances — this is the documented workaround for the `T.Modules` definition diamond blocking
  `Epi` instance search; appropriate, not bad practice
- **Verdict:** Active construction site. 6 honest sorries in two independent chains;
  new iter-054 infrastructure is axiom-clean.

---

### 10. `Picard/FlatteningStratification.lean` (3059 lines) — **modified this iter**
- **Code sorries:** 2
  - Line 2912: `gf_common_basicOpen_basis` — `refine ⟨g, ?_, hg_mem, hg_le_O, ?_, ?_⟩ <;> sorry`;
    3 sub-goals remain; NOTE at line 2888 explains the geometric crux (cross-chart basic-open
    realisation not packaged in Mathlib)
  - Line 3057: `genericFlatness` — full body `sorry`; extensive roadmap (lines 3019–3056) explains
    the two remaining pieces: assembly (A) flat-locality reduction + assembly (B) cover scaffold
- **Honest vs laundered:** Both are honest. `gf_common_basicOpen_basis` is a genuine partial proof
  (Steps 1–2 complete, Step 3 remaining). `genericFlatness` is an acknowledged multi-hundred-LOC build.
- **Axiom cleanliness of `genericFlatnessAlgebraic` (line 1982):** CLEAN — the dévissage proof
  (`by_cases hAM`, primary route + `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`,
  three branches L1/L3/L4+L5) is complete through line 2142 with no inline sorry.
- **`set_option maxHeartbeats` overrides:** Multiple instances (values up to 4000000) throughout
  the file; all are justified by deep localisation instance synthesis chains.

#### ⚠ STALE DOCSTRING FOUND (line 1957):
In the documentation block for `genericFlatnessAlgebraic` (the bullet point
`* **Surviving residue** (\`sorry\` this iter):` at lines 1957–1964), the phrase "(`sorry` this iter)"
asserts the dévissage branch is still a sorry. The actual theorem body (line 1988–2142) is
**complete and axiom-clean** — this label is stale from when the dévissage was being built.
A reader encountering this docstring would incorrectly believe the theorem is incomplete.
**This is a must-fix.**

- **Verdict:** 2 honest open sorries; one stale docstring that must be corrected this iter.

---

### 11. `Cohomology/FlatBaseChange.lean` (2621 lines)
- **Code sorries:** 4
  - Line 1949: `base_change_mate_gstar_counit_transport` — honest parked sorry; a detailed
    comment (lines 1940–1948) describes the 2-stage assembly (A-level identity + γ-pushforward
    transport) and names the verified scaffolds; parked per the iter-043 reversal decision
  - Line 2416: `base_change_mate_gstar_transpose` — the keystone crux sorry; parked after
    the iter-043 determination that the "affine tilde-transport / sections_direct" pivot is
    illusory; all of Seam-2 + Seam-3 depends on this; carries `base_change_mate_gstar_counit_transport`
    as a downstream dependent
  - Line 2597: `affineBaseChange_pushforward_iso` — honest; comment (lines 2588–2595) explains
    the restriction-compatibility of `pushforwardBaseChangeMap` is Mathlib-absent (multi-hundred-LOC);
    references `informal/affineBaseChange_pushforward_iso.md`
  - Line 2619: `flatBaseChange_pushforward_isIso` — honest; comment (lines 2609–2618) gives
    Stacks 02KH roadmap (Čech cohomology + affine-cover infrastructure for `SheafOfModules`;
    Mathlib-absent)
- **Honest vs laundered:** All 4 are honest and well-documented.
- **Axiom cleanliness of non-sorry decls:** Appears clean based on audit. The long chain of
  Seam-0/1/2 scaffolds (`base_change_mate_extendScalars_inner_value_counit`, etc.) all have
  real bodies.
- **Suspect patterns:** `base_change_mate_gstar_transpose` (line 2416) has been "parked"
  since iter-043; the accumulating sorry-chain at lines 1949 and 2416 represents a substantial
  structural gap in the FBC proof. Not an excuse-comment, but the strategic status (escalate vs.
  park) should be reflected in the `task_results` handoff.
- **Verdict:** 4 honest sorries; two form a parked chain (FBC keystone); two are Mathlib-absent
  infrastructure gaps. No laundering.

---

## Flagged issues

### Must-fix-this-iter

**[MUST-FIX] `FlatteningStratification.lean:1957` — Stale "(`sorry` this iter)" in `genericFlatnessAlgebraic` docstring**

The "Surviving residue" bullet of the `/-- **Generic flatness, algebraic form** … -/` docstring
reads `* **Surviving residue** (\`sorry\` this iter)` at line 1957. However, the theorem body
beginning at line 1988 is fully proved and axiom-clean (all three branches of the dévissage
are complete through line 2142). This comment is a left-over from the construction phase and
now misinforms any reader about the status of the theorem.

**Fix:** Remove or update the "(`sorry` this iter)" label in the bullet. The bullet should
read something like: "**Dévissage residue** (proved this iter): …" or simply restructure the
docstring to describe the completed proof.

---

### Major

**[MAJOR] `GrassmannianQuot.lean:271` — `glue` gates 3 further sorries**

The `glue` body sorry (module descent over `GlueData`) is the gating blocker for
`universalQuotient` (347), `tautologicalQuotient` (356), and `represents` (605). Until
`glue` lands, four of the six sorries in this file cannot be closed. The cocycle hypotheses
recorded in the signature are correct infrastructure (C1/C2 from `chartQuotientMap_epi` +
`pullbackBaseChangeTransport`); the remaining work is the actual gluing descent.

**[MAJOR] `GrassmannianQuot.lean:524` — `pullbackObjUnitToUnit_comp` genuine obstruction**

The "PARTIAL" sorry documents a real coherence gap (`conjugateEquiv_pullbackComp_inv` +
whnf timeout). This also gates `functor.map_comp` (line 595). The obstruction is correctly
identified but has been present since this iter; priority for the functor-level universal
property.

**[MAJOR] `FlatBaseChange.lean:2416` — FBC keystone `base_change_mate_gstar_transpose` parked since iter-043**

The sorry at line 2416 is the crux of the entire FBC proof chain (Seam-2 legs-reindex +
Seam-3). The iter-043 reversal established that the "sections_direct" pivot is illusory.
The carry-forward path (escalate or park) should be explicitly stated in the handoff; a
reader of the code alone cannot tell whether this is actively worked or indefinitely parked.
The downstream sorry at line 1949 (`base_change_mate_gstar_counit_transport`) is parasitic
on this one.

---

### Minor

**[MINOR] `FlatteningStratification.lean:2912` — `gf_common_basicOpen_basis` partial proof**

Steps 1–2 are completed; Step 3 (cross-chart basic-open realisation) remains. The NOTE at
line 2888 correctly identifies this as a Mathlib gap (not a lazy sorry). The partial proof
form `refine ⟨g, ?_, …⟩ <;> sorry` is honest; the three remaining sub-goals are the
existential witness body and two basic-open-containment/equality conditions.

**[MINOR] `FlatBaseChange.lean:2597,2619` — infrastructure gap sorries**

`affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` are both
acknowledged Mathlib-absent infrastructure (Čech cohomology / QC restriction-compatibility).
Well-documented; no concern other than being open.

**[MINOR] `FlatteningStratification.lean` — multiple `set_option maxHeartbeats` overrides**

Values up to 4 000 000 appear several times, always adjacent to the deep
localisation/instance-synthesis chains they cover. All are justified; none are "just in case"
overrides masking a broken proof. Worth noting for downstream CI performance.

---

## Excuse-comments audit

**No genuine excuse-comments found.**

The "NOTE (scaffold)" docstring pattern in `GrassmannianQuot.lean` (lines 271, 347, 356, 605)
documents open work honestly and correctly describes what is missing. It sits at the edge of
excuse-comment territory — a scaffold docstring should not read as "this is already correct,
just needs filling" when the body is `sorry` — but it is not hiding a known-wrong proof.

The stale "(`sorry` this iter)" label at `FlatteningStratification.lean:1957` is a **stale
claim** (asserting incompleteness when the proof is complete), not a classic excuse-comment
(admitting wrong code). Classified as must-fix above.

---

## Sorry inventory summary

| File | Code sorries | Honest | Laundered |
|------|-------------|--------|-----------|
| `AlgebraicJacobian.lean` | 0 | — | — |
| `Cohomology/RegroupHelper.lean` | 0 | — | — |
| `Cohomology/FlatBaseChangeGlobal.lean` | 0 | — | — |
| `Cohomology/FlatBaseChange.lean` | 4 | 4 | 0 |
| `Picard/RelativeSpec.lean` | 0 | — | — |
| `Picard/GradedHilbertSerre.lean` | 0 | — | — |
| `Picard/SectionGradedRing.lean` | 0 | — | — |
| `Picard/GrassmannianCells.lean` | 0 | — | — |
| `Picard/QuotScheme.lean` | 4 | 4 | 0 |
| `Picard/GrassmannianQuot.lean` | 6 | 6 | 0 |
| `Picard/FlatteningStratification.lean` | 2 | 2 | 0 |
| **Total** | **16** | **16** | **0** |

---

## Severity summary

| Level | Count | Items |
|-------|-------|-------|
| Must-fix-this-iter | 1 | Stale "(`sorry` this iter)" docstring in `genericFlatnessAlgebraic` |
| Major | 3 | `glue` gating chain; `pullbackObjUnitToUnit_comp` obstruction; FBC keystone parked status |
| Minor | 3 | `gf_common_basicOpen_basis` partial; FBC infra-gap sorries; heartbeat overrides |
| No issue | 7 | Seven fully-clean files |

---

## Final verdict

**Healthy.** 16 code sorries across 4 files, all honestly documented with clear roadmaps and
no laundering. The iter-054 additions (`pullbackBaseChangeTransport`, `glueData_bridge_*`,
`genericFlatnessAlgebraic` dévissage completion, `functor.map_id`, etc.) are axiom-clean.
One must-fix: remove the stale "(`sorry` this iter)" label from the `genericFlatnessAlgebraic`
docstring — the theorem is complete and the label is now misleading. Dominant structural
open items are the GrassmannianQuot `glue` descent and the FBC keystone crux, both correctly
identified in the sorry bodies.
