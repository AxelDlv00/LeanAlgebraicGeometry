# Recommendations for the next plan iteration (post iter-011)

All 5 review subagents returned **0 must-fix**. Build GREEN, blueprint-doctor CLEAN, every
`sorry` honest. The items below are prioritization + cleanup, not blockers.

## Progress-critic tripwire dispositions (read first)

The iter-011 plan set four watch conditions. Their outcomes:

- **FBC tripwire** ("section_identity doesn't close AND sorry doesn't drop → CHURNING"): **did NOT
  fire.** Sorry count dropped −2 (the `map_smul'` wall closed via the `erw` unlock); the
  section-identity statement is formalized with a now-**computable** RHS. Genuine progress — NOT
  churning. BUT see "do not raw-redispatch" below.
- **GF tripwire** ("fewer than 2 of 4 sub-lemmas close → reassess"): **CLEARED** — all 3 L5b
  sub-lemmas closed axiom-clean. GF is converging.
- **GR tripwire** ("3rd zero-output → diagnose harness wall"): **CLEARED decisively** — 16 decls
  landed, GREEN. The effort-break + fast-path fully resolved the 2-iter STUCK.
- **QUOT**: first prover data point — the annihilator-predicate path landed 5 clean decls; the
  forward characterization is genuinely infra-blocked (not avoidance).

## Prioritize next (closest-to-completion)

1. **GF `gf_torsion_reindex` (the GF critical path).** Only the final assembly `sorry` (line 949)
   remains; the 3 sub-lemmas are in place and chain with the right types. Each remaining step's
   Mathlib anchor is already scouted: quotient action `Module.IsTorsionBySet.module`; finiteness
   `Module.Finite.of_restrictScalars_finite`; localization `MvPolynomial.isLocalization`. ~120–180
   LOC of instance/diamond management. If a single prover pass stalls on the diamonds,
   **effort-break the plumbing** (double-localization of `T` / quotient action / loc-commutes-quotient
   are 3 natural seams). Landing this unblocks L5 `exists_localizationAway_finite_mvPolynomial` and
   the downstream L4/algebraic-core.

2. **GrassmannianCells `cocycleCondition` (next leaf).** Needs a `% LEAN SIGNATURE` in the
   blueprint first (it had none, so the prover correctly skipped it). Dispatch a blueprint writer /
   effort-break for `lem:gr_cocycle` to author the signature + decomposition, THEN a prover. The
   file demonstrably accepts large clean output now.

## Do NOT raw-redispatch (needs a structural/blueprint step first)

3. **FBC `base_change_mate_section_identity` — writer round BEFORE any prover.** The RHS is now
   computable, but the LHS adjoint-mate coherence crux (line 1011) is Mathlib-absent and the
   **blueprint sketch is under-specified on the formalization path** (lvb-fbc major finding). A raw
   re-dispatch would churn. Have a blueprint writer / effort-breaker decompose the LHS into the 3
   named sub-lemmas the prover identified: (a) `pullbackPushforwardAdjunction` unit value =
   base-change unit; (b) `f_* = restrictScalars φ` reindex via the pushforward pseudofunctor
   identities; (c) `(g*⊣g_*)` transpose for `ψ` — each relating the adjunction transpose to the
   tilde-dictionary isos on global sections.

4. **FBC `affineBaseChange_pushforward_iso` — BLOCKED, leave deferred.** Transitively depends on the
   section-identity crux AND needs a multi-hundred-LOC restriction-compatibility blueprint
   decomposition. Do not target until (3) lands and a writer decomposes the restriction build.

5. **QUOT `qcoh_section_localization_basicOpen` — BLOCKED, genuine Mathlib infra gap.** Mathlib
   (pinned commit) has no `IsLocalizedModule` bridge for QCoh `SheafOfModules` sections on basic
   opens of a general scheme (only ring-level `Γ_restrict_isLocalization` + affine `Tilde`). Needs a
   multi-iter blueprint decomposition of the QCoh→IsLocalizedModule bridge before ANY prover. The
   annihilator forward characterization is gated on it; keep both deferred.

## Blueprint prose / signature reconciliation (writer tasks)

- **FBC `lem:base_change_mate_regroupEquiv`** (lvb-fbc major): the prose says the `R'`-linear equiv
  is "supplied by the standalone helper `lem:base_change_regroup_linearEquiv`," but the landed Lean
  builds it **inline** via the `eT` identity-bridge + `TensorProduct.induction_on` (the
  `Algebra.IsPushout.cancelBaseChange` route was attempted and **abandoned** — it forces the
  canonical `Algebra A (A⊗R')` and clashes with the `extendScalars` diamond). The helper is
  imported but never called. Update the prose to match the landed structure (or note the helper as
  the conceptual content vs. the realized route).
- **GR `lem:gr_transition_pre_unit`** (lvb-grcells minor): stale `\uses{lem:mathlib_isUnit_iff_isUnit_det}`
  — the dependency is listed but not used in the proof. Remove it.
- **GF `lem:gf_mvPolynomial_quotient_finite_monic`**: resync the `% LEAN SIGNATURE` to the landed
  `RingHom.Finite` encoding (a `% NOTE` was added by review; math statement unchanged).

## Blueprint coverage debt (18 unmatched `lean_aux` nodes — author blocks)

`archon dag-query unmatched` reports 18 prover-created decls with no blueprint block. The
**non-private** ones genuinely need blocks; the private Nagata/matrix helpers are optional but
ideally pinned:

- **QuotScheme (non-private — author blocks):** `Scheme.Modules.annihilator_ideal_le` (the
  `ofIdeals` `≤`-inclusion; fold into `def:modules_annihilator`), `Scheme.Modules.schematicSupportι`
  (the closed immersion; attach to `def:schematic_support`). *(lvb-quot flagged both as major.)*
- **GrassmannianCells (substantive helpers — pin via `\lean{}`):**
  `universalMatrix_submatrix_self`, `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`,
  `universalMatrix_map_transitionPreMap`. (Private `mul_submatrix_col` is acceptable unpinned.)
- **FlatteningStratification (private Nagata machinery — low priority):** `T`, `T1`,
  `T_leadingcoeff_eq`, `degreeOf_t_ne_of_ne`, `degreeOf_zero_t`, `finSuccEquiv_map_comm`,
  `finSuccEquiv_rename_succ`, `leadingCoeff_finSuccEquiv_t`, `lt_up`, `sum_r_mul_ne`, `t1_comp_t1_neg`.

## Stale-comment cleanup (prover task — review agent cannot edit `.lean`)

The lean-auditor flagged legacy comments imported verbatim from the source project
(Algebraic-Jacobian-Challenge). They mislead the development narrative — have the FBC file owner
prune them next time it is touched:

- `FlatBaseChange.lean:184–246` — STATUS block referencing **iter-234/236/240/241** (source-project
  iters; this project is at iter-011). Prune or relocate to an attribution note. *(MAJOR)*
- `FlatBaseChange.lean:~1059` — docstring of `pushforward_base_change_mate_cancelBaseChange` says
  "typed `sorry` **below**" but the dependency `sorry` is **above** (line 1011, in
  `base_change_mate_section_identity`). Misleads a reader into thinking the decl is sorry-free; its
  axiom set includes `sorryAx`. Fix "below" → "above". *(MAJOR)*
- `FlatBaseChange.lean:~566, ~632` — inline "iter-240 PIVOT" / "iter-241" legacy noise.
- `GrassmannianCells.lean` — a planner-note block in production source (LOW, cosmetic).

## Reusable proof patterns discovered this iter

- **`erw [TensorProduct.zero_tmul]` through diamond instances.** When a zero-branch goal won't
  rewrite because the `0 ⊗ₜ m` representation is keyed to an opaque `_aux Module` diamond instance,
  `erw` (defeq-matching) closes it where `rw`/explicit-typed-`show`/`convert` all fail with
  "pattern not found" / "stuck metavariable instance". This unlocked the multi-iter FBC `map_smul'`
  wall.
- **Domain-adapting Mathlib's field-only private machinery.** Mathlib's Noether-normalization Nagata
  transform is private + field-only; transcribe it to a noetherian domain by returning the leading
  coefficient as `C (coeff v f)` (non-zero in a domain) instead of asserting it is a unit, then
  localize at that coefficient (`IsLocalization.Away.algebraMap_isUnit`) to recover the unit.
- **Namespace shadow:** `open _root_.Polynomial _root_.MvPolynomial _root_.Ideal _root_.RingHom`
  — a bare `open Polynomial` resolves to the project's `AlgebraicGeometry.Polynomial` namespace and
  shadows the root API. Also: use `phi` not `φ` as a binder name (a literal `φ` binder triggered a
  spurious "unexpected token 'φ'" parse error in one editing context).
- **Matrix one-block idioms:** `inv_one` (NOT `Matrix.inv_one` / `Matrix.nonsing_inv_one`, which do
  not exist); `Matrix.one_mul`; `change` not `show` for a defeq goal that `show` rejects as
  "non-trivial"; `IsUnit.of_mul_eq_one _ hmul` (the deprecated `isUnit_of_mul_eq_one` has different
  arity).
