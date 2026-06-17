# Session 11 (iter-011) — Review Summary

## Metadata

- **Iteration:** 011 (first prover iter since the iter-010 DAG re-elaboration).
- **Lanes dispatched (4, import-independent):** FBC-A (FlatBaseChange), GF-alg
  (FlatteningStratification), GrassmannianCells, QUOT-A (QuotScheme).
- **Prover activity:** 44 edits, 37 lemma searches, 0 fake statements, 0 `axiom`s, 0 weakened
  defs. Every `sorry` is honest scaffolding with an in-code diagnosis.
- **Build:** GREEN. blueprint-doctor CLEAN (0 orphans, 0 broken refs, 0 axioms).
- **sync_leanok:** ran for iter-011 (sha `aa9ebb8`, +60 markers, 0 removed) — all `\leanok` is
  the deterministic verdict.
- **Sorry counts (per file, post-iter):** FBC 3, GF 5, GrassmannianCells **0**, QuotScheme 4.

## Per-target outcomes

### GrassmannianCells.lean — the headline win (STUCK → GREEN)
**16 declarations landed, all axiom-clean, sorry-free, `lake build` GREEN (8317 jobs).** This
file produced **zero** committed edits in iter-008 and only a GREEN no-op in iter-009 (a 2-iter
STUCK). The iter-011 plan effort-broke the monolithic `def:gr_transition` into 8 small leaves +
5 verified Mathlib anchors and took the sanctioned same-iter fast path; that removed the root
cause (one giant `def`). Landed chain: `universalMatrix → minorDet → universalMinor →
universalMinorInv` (Cramer) `→ imageMatrix → transitionPreMap → transitionMap`
(`IsLocalization.Away.lift`), plus `transitionMap_self` (`lem:gr_transition_self`) and the
`isUnit`/minor-identity helpers.
- Key fixes: `inv_one` (not the non-existent `Matrix.inv_one`/`Matrix.nonsing_inv_one`);
  `change` not `show` for the defeq identity goal; `IsUnit.of_mul_eq_one _ hmul` (the deprecated
  `isUnit_of_mul_eq_one` needs a different arity).
- Deliberately stopped before `cocycleCondition` (next leaf, no `% LEAN SIGNATURE` yet).

### FlatBaseChange.lean — route swap closed the multi-iter `map_smul'` wall
- **`base_change_mate_regroupEquiv`: SOLVED, sorry-free, axiom-clean.** The two `map_smul'`
  zero-branches (the "transparent-instance wall" open since iter-008) closed via
  **`erw [TensorProduct.zero_tmul]`** — `erw` unifies up to defeq through the opaque `_aux`
  `Module R'` instances where `rw` refuses. Net **−2 sorries**.
  - The planned `Algebra.IsPushout.cancelBaseChange` route was *attempted and abandoned*: it forces
    the canonical `Algebra A (A⊗R')` structure, clashing with `extendScalars`' `restrictScalars
    includeLeftRingHom` diamond (`failed to synthesize Module ↑R' …`). The prover reverted to the
    `eT` identity-bridge + hand-closed zero branches. **The blueprint prose still describes the
    helper-supplied route — a prose/Lean mismatch flagged by lvb-fbc, not a correctness issue.**
- **`base_change_mate_section_identity`: PARTIAL.** Renamed from `…generator_trace_eq`, docstring
  reframed to `Γ(θ) = lTensor R' η_M`, consumer rewired. RHS is now computable (regroupEquiv is
  sorry-free); the LHS adjoint-mate coherence crux is a typed `sorry` at line 1011 (Mathlib-absent).
- **`affineBaseChange_pushforward_iso`: BLOCKED** (line ~1142) — restriction-compatibility build,
  multi-hundred LOC, transitively depends on the section-identity crux.
- `flatBaseChange_pushforward_isIso` (FBC-B, ~1164): out of scope, untouched.

### FlatteningStratification.lean — 3 axiom-clean dévissage sub-lemmas landed; assembly remains
- **`gf_torsion_annihilator` (L5b.1): SOLVED** via `Submodule.annihilator_top_inter_nonZeroDivisors`
  (domain ⇒ NZD annihilator = non-zero).
- **`gf_nagata_monic_lastVar` (L5b.2): SOLVED.** Transcribed Mathlib's **field-only private**
  Nagata transform to a **noetherian domain** base (the field is used in Mathlib only to conclude
  the top coefficient is a unit; over a domain it is merely non-zero, recovered after inverting
  `g`). lean-auditor confirmed the adaptation does **not** silently assume a field.
- **`mvPolynomial_quotient_finite_of_monic_lastVar` (L5b.3): SOLVED.** Shared single-variable
  elimination engine. **Encoding deviation:** landed as `RingHom.Finite` of the composite ring map
  rather than the blueprint's `Module.Finite` + `letI : Algebra` sketch — lvb-gf confirmed
  genuinely equivalent; `% NOTE` added (see markers below).
- **`gf_torsion_reindex` (L5b assembly): PARTIAL.** The 3 sub-lemmas chain together with the right
  types (this validates their signatures); the final plumbing (double-localization of `T`,
  `IsTorsionBySet` quotient action, localization-commutes-with-quotient, `Module.Finite.trans`) is
  one residual `sorry`, with each step's Mathlib anchor already scouted.
- Bonus: fixed a build error in L5 `exists_localizationAway_finite_mvPolynomial` (the
  `IsFractionRing.injective` smul-vs-algebraMap mismatch, via `Algebra.algebraMap_eq_smul_one`);
  added `omit [IsDomain k]` to several Nagata helpers; `private`-ized `T1`.

### QuotScheme.lean — annihilator-predicate path landed; QCoh bridge still blocked
- **`Scheme.Modules.annihilator` (def), `annihilator_ideal_le`, `schematicSupport`,
  `schematicSupportι`, `HasProperSupport`: 5 SOLVED, axiom-clean** (via
  `Scheme.IdealSheafData.ofIdeals` + `subschemeι`).
- The DEFINITION is closed without basic-open coherence; only the FORWARD characterization
  (reverse inclusion) remains bridge-gated on `lem:qcoh_section_localization_basicOpen`.
- **`qcoh_section_localization_basicOpen`: BLOCKED.** Mathlib (pinned commit) has no
  `IsLocalizedModule` bridge for QCoh `SheafOfModules` sections on basic opens of a general scheme;
  only the ring-level `Γ_restrict_isLocalization` and the affine `Tilde`. Genuine infra gap.

## Review subagents (5 dispatched, all returned — 0 must-fix)

- **lean-auditor `iter011`** — all four files mathematically honest, 0 must-fix; 5 issues
  (2 major / 3 minor). Report: `task_results/lean-auditor-iter011.md`.
- **lean-vs-blueprint-checker** ×4 — `grcells` PASS (0 red flags); `fbc` 0 must-fix (2 major
  blueprint-adequacy); `gf` 0 must-fix (1 minor); `quot` 0 must-fix (2 major = the 2 coverage-debt
  blocks). Reports under `task_results/lean-vs-blueprint-checker-*-iter011.md`.

See `recommendations.md` for the landed findings.

## Blueprint markers updated (manual)

- `Picard_QuotScheme.tex`, `def:modules_annihilator`: refreshed the `% NOTE` — the definition is
  now formalized (via `ofIdeals`); only the forward characterization remains bridge-gated on
  `lem:qcoh_section_localization_basicOpen`.
- `Picard_FlatteningStratification.tex`, `lem:gf_mvPolynomial_quotient_finite_monic`: added a
  `% NOTE (iter-011 landed-encoding)` recording that the landed decl uses `RingHom.Finite` rather
  than the `Module.Finite` + `letI : Algebra` LEAN SIGNATURE sketch (math content identical).

No `\lean{...}` corrections were needed — all blueprint `\lean{}` pins already match the prover's
chosen names (FBC `…section_identity`, GF sub-lemmas, GR `transitionMap`/`transitionPreMap`). No
`\notready` markers present in the touched chapters. No `\mathlibok` added (no prover decl is a
Mathlib re-export). No orphaned `lem:base_change_mate_generator_trace_eq` block (grep-clean).

## Notes (LOW)

- lean-auditor LOW: a planner-note block sits in GrassmannianCells production source (cosmetic).
- lvb-grcells minor: stale Mathlib anchor `lem:mathlib_isUnit_iff_isUnit_det` listed as a
  `\uses{}` dependency of `lem:gr_transition_pre_unit` but not used in the proof.
