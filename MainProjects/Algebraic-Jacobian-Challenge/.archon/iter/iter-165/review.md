# Iter-165 (Archon canonical) — review

## Outcome at a glance
- **The "depth-conversion scaffold landed" iter.** iter-164's progress-critic flagged iter-165 as
  the MUST-convert-to-depth iter (a second hygiene round would flip Route C to CHURNING). The
  prover phase answered with a single NEW-file lane,
  `AlgebraicJacobian/Genus0BaseObjects.lean` (389 LOC, 4 main objects: `ProjectiveLineBar`, `Ga`,
  `Gm`, `gmScalingP1`). The PARTIAL gate scorecard (plan.md L107–115) was met: **4/4 main objects
  defined, 3/4 with axiom-clean primary instances, 9 plan-allowed scaffold sorries for iter-166's
  AVR consumer lane.**
- **Dispatch MATCHED the plan — 8th consecutive iter** with no plan/dispatch contradiction.
- **Global bare-sorry 6 → 15** (Δ = +9, by design). Per-file inventory:
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean` L936/L960/L989 (3 deferred genus-0 scaffolds,
    unchanged).
  - **NEW** `AlgebraicJacobian/Genus0BaseObjects.lean` L177/L184/L201/L206/L211/L264/L329/L368/L385
    (9 plan-allowed scaffold sorries).
  - `AlgebraicJacobian/Jacobian.lean` L265/L303 (unchanged).
  - `AlgebraicJacobian/RigidityKbar.lean` L88 (unchanged).
  No new `axiom`; no protected signature touched; `lake build AlgebraicJacobian` → green
  (sorry warnings only); blueprint-doctor empty (no orphan chapters, no broken refs, no axioms).

## The advance, independently verified this review
1. **`projectiveLineBar_isProper` (Genus0BaseObjects.lean:127–170) — PROVEN, axiom-clean.**
   `lean_verify` confirms `{propext, Classical.choice, Quot.sound}`, no `sorryAx`. The
   analogist `gm-scaling-p1` report listed this as "FREE from `Proj.instIsProperToSpecZero…`",
   but the project's encoding wires `ProjectiveLineBar.hom = Proj.toSpecZero ≫
   Spec.map (algebraMap k̄ → ↥(𝒜 0))`, so the prover had to (a) install `IsScalarTower kbar ↥(𝒜 0)
   (MvPolynomial _ kbar)` via `of_algebraMap_eq fun _ => rfl`, (b) prove `algebraMap k̄ → ↥(𝒜 0)`
   bijective (witnesses: `MvPolynomial.C_injective` for injectivity, `MvPolynomial.coeff 0 v` for
   surjectivity, using `homogeneousComponent_of_mem` + `homogeneousComponent_zero` to identify
   degree-`0`-piece = constants), (c) lift to `IsIso (Spec.map _)` via `isIso_SpecMap_iff`, (d)
   `infer_instance` on the composite. The bijectivity step's `simp` resolver is
   `[MvPolynomial.homogeneousComponent_zero, if_true]` — `reduceIte` failed.
2. **5 axiom-clean Mathlib-bridge instances on `Ga` / `Gm`** —
   `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced`, `gm_isAffine`,
   `gm_locallyOfFinitePresentation`, `gm_isReduced`. Notable bridges:
   - `ga_isReduced := isReduced_of_isOpenImmersion (AffineSpace.isoOfIsAffine (Fin 1) _).hom`
     (transports `IsReduced` from `Spec (.of (MvPolynomial _ _))` via the iso).
   - `gm_locallyOfFinitePresentation := (HasRingHomProperty.Spec_iff (P :=
     @LocallyOfFinitePresentation)).mpr ((RingHom.finitePresentation_algebraMap _).mpr
     inferInstance)` (the morphism-property ↔ ring-hom-property bridge for `Spec.map`-shaped
     morphisms).
3. **`gmScalingP1 : ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar`** — type signature lands
   (per analogist D3: bare ⊗-morphism, NO `IsAction`/`MulAction`-style typeclass at scheme level).
   Body deferred to iter-166's `Scheme.Cover.glueMorphisms` lane.
4. **`gmScalingP1_collapse_at_zero`** — STATEMENT lands matching the rigidity consumer's `_hf`
   shape verbatim:
   `lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫ gmScalingP1 kbar
   = toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar`. This is precisely the antecedent
   `hom_additive_decomp_of_rigidity` (proven Cor 1.5) consumes when iter-166's AVR proof
   instantiates with `V = ProjectiveLineBar`, `W = Gm`, base points `zeroPt`, `Gm.onePt`.

## Is this iter-157 laundering again? No.
Explicitly checked. The 9 new sorries are all top-level NAMED declarations (no buried
`letI`/`have :=` sorries in otherwise-closed proofs — auditor-confirmed
`logs/iter-165/lean-auditor-iter165-report.md:197-205`). `ga_smooth` / `gm_smooth` carry
`sorryAx` honestly via their `_grpObj` upstreams (verified by `#print axioms`); the chain
`have : GrpObj (Over.mk _.hom) := <_grpObj kbar>; smooth_of_grpObj_of_isAlgClosed _.hom` is
logically valid modulo the upstream scaffolds and propagates `sorryAx` without laundering.
The Rigidity-Lemma chain (`rigidity_lemma`, `hom_additive_decomp_of_rigidity`,
`av_regularMap_isHom_of_zero`) re-verified axiom-clean
(`{propext, Classical.choice, Quot.sound}`) — unchanged this iter.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix introduced)
| Subagent | Slug | mf / maj / min | Headline |
|---|---|---|---|
| `lean-auditor` | iter165 | 0 / 5 / 4 | The new file is structurally sound; `projectiveLineBar_isProper` audited and confirmed (no laundering, no buried sorries, the `change`-to-`Proj.toSpecZero ≫ Spec.map` chain holds by defeq, bijectivity computation explicit). `ga_smooth` / `gm_smooth` propagate `sorryAx` honestly. 5 majors are unchanged carry-overs from iter-164's stale-narrative debt (`Cotangent/GrpObj.lean ×2`, `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean ×2`, `Jacobian.lean`). 4 minors: 3 carry-overs + 1 NEW borderline excuse-comment on the `ga_grpObj` docstring ("**PARTIAL placeholder** … does not exercise this") — auditor recommends rewording to "scaffold body for iter-166; off-path for the genus-0 closure". |
| `lean-vs-blueprint-checker` | g0bo-iter165 | 0 / 0 / 3 | Both `\lean{...}` pins in `AbelianVarietyRigidity.tex` (the consolidated chapter that now covers `Genus0BaseObjects.lean` via `% archon:covers`) — `def:genus0_base_objects → ProjectiveLineBar` and `def:gaTranslationP1 → gmScalingP1` — point to the correct Lean targets with signature-faithful encodings. Forward-acyclic `\uses`. No false `\leanok` (verified by grep on the chapter). 3 minors are chapter-side coverage gaps (missing `\lean{...}` hints for `Ga`/`Gm`/`Gm.onePt`/the three ℙ¹ points/`gmScalingP1_collapse_at_zero`; and a prose-trim suggestion on `def:gaTranslationP1` claiming MulAction-style identities the Lean intentionally does not ship). All chapter-side — blueprint-writer's lane for the next plan iter. |
Reports: `logs/iter-165/{lean-auditor-iter165,lean-vs-blueprint-checker-g0bo-iter165}-report.md`.

## Persistent infra issue (carry-over)
The `.debug-feedback/debug_feedback.md` note from iter-164 about false `\leanok` markers on
sorry-bodied targets (sync_leanok keyword-stripping) is still unaddressed. iter-165 did not
introduce a fresh instance, and the checker confirmed that `def:genus0_base_objects` and
`def:gaTranslationP1` are currently `\leanok`-free (verified by grep). The blueprint-doctor
this iter found nothing. The infra concern is therefore quiescent this iter, but the iter-163
CRITICAL recommendation it represents remains an open `.debug-feedback` item.

## Actions taken this review
- Wrote `proof-journal/sessions/session_165/{milestones.jsonl, summary.md, recommendations.md}`.
- Wrote `iter/iter-165/review.md` (this sidecar).
- Updated `PROJECT_STATUS.md` Knowledge Base (5 new entries on the iter-165 patterns +
  `Genus0BaseObjects.lean` row in Files-in-scope).
- Updated `TO_USER.md` banner: depth-conversion scaffold landed; iter-166 = AVR refactor lane.
- Did NOT touch any `\leanok` (deterministic-sync's domain).
- Did NOT touch the blueprint chapter — the 3 minor coverage gaps the checker flagged are
  writer-domain edits (substantive `\lean{...}` block additions + prose trim); recorded in
  `recommendations.md` for the iter-166 blueprint-writer dispatch.
- Did NOT touch `.lean` files (review agent permissions). The borderline excuse-comment on
  `ga_grpObj` is captured in `recommendations.md` MEDIUM section for the iter-166 prover to
  reword in passing.

## For the next plan agent (see recommendations.md)
1. **CRITICAL — Dispatch the AVR refactor lane**: `import AlgebraicJacobian.Genus0BaseObjects`;
   refactor `morphism_P1_to_grpScheme_const` to the concrete `ProjectiveLineBar`/`Gm`/`gmScalingP1`
   triple; body via Cor 1.5 + the scaling-shortcut chain. iter-166 watch tripwire is alive.
2. **HIGH — Close `gm_grpObj`** (the only `_grpObj` scaffold the live consumer exercises) via
   `GrpObj.ofRepresentableBy` with units functor + `IsLocalization.Away`-Spec bijection.
3. **HIGH — Close `gmScalingP1` body + `gmScalingP1_collapse_at_zero`** (the load-bearing
   morphism + companion lemma); chartwise glue via `Scheme.Cover.glueMorphisms`.
4. **MEDIUM — Blueprint-writer dispatch on `AbelianVarietyRigidity.tex`** for the 3 minor
   chapter-side coverage gaps (per-decl `\lean{...}` hints + companion-lemma block + prose trim).
5. **MEDIUM — Stale-narrative purge** (5 files, carry-over from iter-164, axiom-clean code but
   stale framing). Bundle with the iter-166 close-out hygiene round.

## Subagent skips
- (none) — both highly-recommended review subagents dispatched (`lean-auditor`,
  `lean-vs-blueprint-checker`).
