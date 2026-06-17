# Lean Audit Report

## Slug
aud257

## Iteration
257

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/LineBundleCoherence.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L9: Header says "iter-256 Lane engine" — mildly stale (now in iter-257). Minor.
  - L27: Header block "Status (iter-257 bodies opened: 5 sorry → 1)" will date and
    become misleading in subsequent iterations. Minor.
  - L87–88: "The de-risk outcome … is recorded in the task result and probed by the
    `#check` commands at the end of this file." There are **no** `#check` commands in
    the file (it ends at L289). The sentence is either referencing removed probe code
    or a result file; as written it is incorrect. Minor.
  - L206: `chartOverIso` — single `sorry`.  Type is honest:
    `M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U)`.  Docstring correctly
    explains the blocker (modules-level shadow of `Opens.overEquivalence`).  No
    vacuous body.  Every downstream declaration (`chartPresentation` L214,
    `isFinitePresentation` L236, `isFiniteType` L264) chains through it and is
    genuinely incomplete without it — no silent vacuity.  The `IsFinite` instance at
    L221–225 (`infer_instance` on `Presentation.ofIsIso`) is syntactically valid and
    would survive once `chartOverIso` is closed.
  - `exists_trivializing_cover` (L121), `freeUnitIso` (L147), `unitGenerators` (L153),
    `unitPresentation` (L163), `chart_free_rank_one` (L279): all complete and clean.
    `unitPresentation.relations.epi` proof uses `Limits.isZero_kernel_of_mono _` on a
    mono-of-iso — correct usage.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
*(audited: header L1–100, L2110–2229; sorry inventory via grep covering full file)*

- **outdated comments**: 2 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - **L43** (header): "There is now ONE tracked typed-`sorry` residual: the deferred
    `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L690, cross-file gated)."
    **Stale**: the file currently has **two** `sorry` sites — L715
    (`exists_tensorObj_inverse`) and L2220 (`pullbackTensorMap_restrict`).  The header
    does not account for the new L2220 sorry introduced this iteration.  **Major.**
  - **L2121–2125**: `toRingCatSheafHom_comp_hom_reconcile` closes by `rfl` — clean,
    private, correctly typed.  No issue.
  - **L2199–2201** (inside the ROADMAP comment of `pullbackTensorMap_restrict`):
    "ITER-257 FINDINGS (1) The Sq2 RING-MAP RECONCILIATION IS DEFINITIONAL —
    `toRingCatSheafHom_comp_hom_reconcile` (just above) closes by `rfl` …"  This
    finding describes work **already realized** by the private lemma immediately above
    the sorry; the ROADMAP comment now refers to completed work as if it were still
    outstanding.  The "ITER-257 FINDINGS" framing is iteration-specific and will age.
    **Major** (stale internal comment; may mislead the next prover about what remains).
  - **L2157–2219** (rest of ROADMAP block): mathematically precise description of the
    genuine obstacles (Sq2b mate-calculus, Sq1/Sq4 sub-lemmas).  Not an excuse-comment;
    the plan is specific and honest about difficulty.  Minor: iteration labels
    ("iter-256 handoff") will age.
  - **L715**: `exists_tensorObj_inverse` sorry — correctly tracked, body comment
    accurately describes two remaining bridges (C, A).
  - **L2220**: `pullbackTensorMap_restrict` sorry — new this iteration.  Statement is
    honestly typed (composition coherence of `pullbackTensorMap`).  The ROADMAP
    comment explains why the unit-analog mirror doesn't apply and names the three
    required sub-lemmas.  Honest sorry.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - **L18** (header): "one `sorry` remains at the identified Step-4 presheaf residual
    … `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`."
    **Stale**: the file has **two** sorries — L210 (`sliceDualTransport`, the sectionwise
    building block) and L323 (the `isoMk` naturality assembly).  The Step-4 residual
    has been decomposed; the header still describes the pre-decomposition state.  The
    cited line "~L254" for the sorry is also wrong (sorries are at L210 and L323).
    **Major.**
  - **L355, L357** (in `dual_isLocallyTrivial` docstring): "dual_restrict_iso is
    PARTIAL — Step-4 sorry at ~L254".  Same stale line reference — sorry is at L210,
    not ~L254.  Minor.
  - **L207–209** (`sliceDualTransport` construction plan): "Verification is currently
    blocked by the concurrently-broken `TensorObjSubstrate.lean` dependency (cross-lane
    TS-cmp edit); the body is left as a typed `sorry` at the intended signature pending
    a green dependency build."  The phrase "concurrently-broken … dependency" attributes
    the sorry to a transient CI/edit state rather than a mathematical gap.  This is an
    implementation-timeline note, not a description of the real blocker (the
    construction of the sectionwise `𝒪_Y(V)`-linear equivalence).  **Major** —
    misleads future provers about the nature and permanence of the blocker.
  - **L639** (inside completed `homOfLocalCompat` proof): "the SOLE remaining `sorry`
    is the inner ring-bridge (linearity of the `homLocalSection`-component over `X`'s
    structure ring through the open-immersion `appIso`)."  The `homOfLocalCompat` proof
    has **no sorry** (verified by grep — only sorries in the file are at L210 and L323).
    This comment describes a sorry that was subsequently closed; the comment is stale
    and incorrectly implies the proof is incomplete at this point.  **Major.**
  - **L210**: `sliceDualTransport` — `sorry` with a 30-line construction plan.  Plan is
    mathematically specific (homLocalSection-style, thin-poset Subsingleton.elim for
    naturality, `𝒪_Y(V)`-linear equivalence via `iso_inv ∘ hom` conjugation).  The
    body quotes a reference to `dualPrecompEquiv` that I could not independently verify
    exists in scope; if absent, the plan would overstate readiness.  Classified as minor
    pending verification that `dualPrecompEquiv` resolves.
  - **L323**: naturality sorry in `dual_restrict_iso` (`isoMk` coherence after
    `sliceDualTransport`).  Honest: comment at L318–320 correctly explains it reduces to
    Subsingleton.elim once `sliceDualTransport` is concrete.
  - `dual_isLocallyTrivial` (L399–408): clean three-step chain, no sorry in body.
    Inherits `dual_restrict_iso` sorry axiomatically.
  - `dual_unit_iso` (L341–346), `presheafDualUnitIso` (L330–334),
    `dualUnitIsoGen` (L108–142), `unitDualSectionEquiv` (L66–103),
    `homLocalSection` (L422–471), `topSectionToHom` (L479–487),
    `topSectionToHom_app` (L492–497), `image_preimage_of_le` (L503–506),
    `homOfLocalCompat` (L580–748): all complete, no sorry.
  - Embedded `/- Planner strategy: … -/` blocks inside declaration docstrings
    (L222–289 inside `dual_restrict_iso`; L352–397 inside `dual_isLocallyTrivial`):
    long in-file strategy notes with iteration-specific references.  Not incorrect or
    misleading, but they will age and add non-Lean noise.  Minor.

---

## Must-fix-this-iter

- `LineBundleCoherence.lean:206` — `chartOverIso := sorry`.  Load-bearing:
  `chartPresentation`, `isFinitePresentation`, `isFiniteType` all depend on it.
  Why must-fix: `:= sorry` on the sole substantive claim gating three downstream decls.

- `TensorObjSubstrate.lean:715` — `exists_tensorObj_inverse := sorry`.  Load-bearing:
  the `⊗`-inverse lane feeding the Picard group law.  (Already tracked; listed for
  completeness as the rule applies regardless of tracking status.)

- `TensorObjSubstrate.lean:2220` — `pullbackTensorMap_restrict := sorry`.  Load-bearing:
  consumed by D4′ `pullbackTensorIsoOfLocallyTrivial`.
  Why must-fix: new sorry not reflected in the file header; substantive claim.

- `TensorObjSubstrate/DualInverse.lean:210` — `sliceDualTransport := sorry`.
  Load-bearing: the sectionwise building block of `dual_restrict_iso`.
  Why must-fix: `:= sorry` on the core Step-4 construction.

- `TensorObjSubstrate/DualInverse.lean:323` — `dual_restrict_iso` naturality := sorry`.
  Load-bearing: assembly step of `dual_restrict_iso` (an `isoMk` coherence goal).
  Why must-fix: derivative of L210 but still a `sorry` on a substantive obligation.

---

## Major

- `TensorObjSubstrate.lean:43` — Header claims "ONE tracked typed-`sorry` residual"
  but the file has two sorries (L715, L2220).  Misleads any reader of the status block.

- `TensorObjSubstrate.lean:2199–2201` — ROADMAP "ITER-257 FINDINGS (1)" is stale:
  describes work already realized by `toRingCatSheafHom_comp_hom_reconcile` at L2121.
  May mislead the next prover into thinking Sq2 reconciliation is still open.

- `TensorObjSubstrate/DualInverse.lean:18` — Header claims "one `sorry` remains" but
  the file has two sorries (L210, L323); stated location "~L254" is wrong.

- `TensorObjSubstrate/DualInverse.lean:207–209` — Attributes the `sliceDualTransport`
  sorry to a "concurrently-broken … dependency" rather than to the mathematical build
  being incomplete.  Phrasing misrepresents the nature of the blocker.

- `TensorObjSubstrate/DualInverse.lean:639` — Inside the completed `homOfLocalCompat`
  proof, a comment says "SOLE remaining `sorry` is the inner ring-bridge" — the sorry
  has been closed; this comment is stale and contradicts the actual proof state.

---

## Minor

- `LineBundleCoherence.lean:9` — "iter-256 Lane engine" in module docstring; stale.
- `LineBundleCoherence.lean:87–88` — References "#check commands at the end of this file"
  that do not appear; stale or referencing removed probe code.
- `TensorObjSubstrate.lean:2157–2219` — ROADMAP comment contains iteration-specific
  labels ("iter-256 handoff", "ITER-257 FINDINGS") that will age in subsequent iters.
- `TensorObjSubstrate/DualInverse.lean:355,357` — "Step-4 sorry at ~L254" is a stale
  line reference; sorries are now at L210 and L323.
- `TensorObjSubstrate/DualInverse.lean:210` — Construction plan cites `dualPrecompEquiv`
  without confirming it exists in scope.  If absent, the plan overestimates readiness.
  (Verification requires a live build.)
- `TensorObjSubstrate/DualInverse.lean:222–289,352–397` — Long embedded
  `/- Planner strategy: … -/` blocks inside declaration docstrings carry
  iteration-specific references and will age.

---

## Excuse-comments (always called out separately)

None found.  The "blocked by the concurrently-broken … dependency" note at
`DualInverse.lean:207–209` is borderline — it attributes a sorry to an external
timeline rather than a mathematical gap — but falls short of the "admitting the
code is wrong / will fix later" threshold.  It is flagged at Major rather than
must-fix.

---

## Severity summary

- **must-fix-this-iter**: 5 — these block downstream work until addressed.
- **major**: 5
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: The three files are in honest shape — all sorries are correctly typed with no vacuous or misleading bodies — but the file headers and two in-proof comments are stale about sorry counts and locations, which risks misleading future provers about what remains to be built.
