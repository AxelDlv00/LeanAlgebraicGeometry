# Iter-135 (Archon canonical) — review

## Outcome at a glance

- **No prover lane fired this iter.** Iter-135 was a plan-only +
  parallel-writer + parallel-refactor iter. `meta.json`:
  `planValidate.status: ok_intentional_skip`,
  `prover.durationSecs: 0`, `prover.status: done`. Per the iter-132
  META-PATTERN TRIPWIRE non-promise commitment + the iter-135
  progress-critic's "address the placeholder pattern before more
  prover bandwidth", the planner correctly chose a plan-phase
  refactor over another prover dispatch on Route 4 (piece (i.b)).
- **9 subagent dispatches all returned cleanly**:
  - **6 plan-phase**: 3 mandatory critics (`strategy-critic-iter135`
    SOUND with 1 CHALLENGE + 2 minor alternatives, all absorbed or
    rebutted; `blueprint-reviewer-iter135` 5 chapters partial + 1
    bonus orphan, HARD GATE vacuous this iter; `progress-critic-iter135`
    1 CONVERGING + 3 UNCLEAR / 0 CHURNING / 0 STUCK) + 1
    `mathlib-analogist-phi-compatibility-morphisms-iter135`
    (PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN + ALIGN_WITH_MATHLIB on
    `Scheme.Hom.toRingCatSheafHom` as the canonical
    `PresheafOfModules.pullback` compatibility-morphism idiom;
    persistent file `analogies/phi-compatibility-morphisms.md`) + 1
    refactor (`refactor-grpobj-and-jacobian-iter135` 9 sub-changes
    landed; no new axioms) + 3 blueprint-writers (`rigiditykbar-iter135`
    560 → 586 LOC; `mayervietoris-iter135` 3 broken refs fixed;
    `jacobian-iter135` new `\subsection{...positive-genus arm...}`).
  - **3 review-phase**: `lean-auditor-review135` (6 must-fix all
    load-bearing sorries + 0 excuse-comments + 0 major + 3 minor;
    headline "iter-135 refactor is a legitimate honesty
    improvement"), `lean-vs-blueprint-checker-cotangent-grpobj-review135`
    (PASS, 0 must-fix / 0 major / 1 minor — partial L61/L107/L146/L155/L160
    file-header line-anchor de-pinning),
    `lean-vs-blueprint-checker-jacobian-review135` (clean, 0 must-fix /
    0 major / 1 minor — stale citation `Jacobian.tex:400`).
- **Net sorry change**: **4 → 6** (+2; **semantic-health-positive**).
  The increase reflects: (a) 3 iter-134 weakened-wrong placeholders
  (`Nonempty (X ≅ X) := ⟨Iso.refl _⟩` shape, machine-undetectable as
  incomplete) REPLACED by 3 honest sorry-bodied scaffolds with intended
  sheaf-level RHS signatures (`sorry_analyzer`-visible incompleteness);
  (b) 1 inline `sorry` on `nonempty_jacobianWitness` REPLACED by a
  `by_cases` decomposition delegating to two pre-existing sorry-bodied
  scaffolds (structural decomposition, no signature change). Per-file
  at iter-135 close:
  - `AlgebraicJacobian/Cotangent/GrpObj.lean`: **0 → 3** sorries
    (3 NEW honest scaffolds at L468/L496/L560 REPLACING 3 prior
    `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` placeholders that
    `sorry_analyzer` could not see).
  - `AlgebraicJacobian/Jacobian.lean`: **3 → 2** sorries (inline
    `:= sorry` on `nonempty_jacobianWitness` REPLACED by `by_cases`
    delegation; the 2 scaffolds `genusZeroWitness` L197 +
    `positiveGenusWitness` L223 unchanged).
  - `AlgebraicJacobian/RigidityKbar.lean`: **1 → 1** sorry (unchanged
    iter-126 `rigidity_over_kbar` scaffold).
- **Compile-verified**: yes. `lean_diagnostic_messages` returns
  exactly the 6 expected `declaration uses sorry` warnings + 1
  pre-existing long-line linter warning on `Jacobian.lean:275`
  (protected signature, do not reformat). `lake build` green per
  the refactor task result (8330/8330 jobs succeed).
- **No new axioms.** `archon-protected.yaml` unchanged (9 protected
  declarations). `lean_verify` on the 4 refactor-touched declarations
  (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
  `relativeDifferentialsPresheaf_restrict_along_identity_section`,
  `mulRight_globalises_cotangent`, `nonempty_jacobianWitness`)
  returns `{propext, sorryAx, Classical.choice, Quot.sound}` — kernel
  + sorry, no project axioms.
- **`current_session/attempts_raw.jsonl` is stale.** The 95 events
  in the file are from the iter-134 prover lane
  (2026-05-17T19:27–19:47Z); iter-135's plan phase started
  2026-05-17T20:12:35Z. Because iter-135 had `prover.durationSecs: 0`,
  the harness did not refresh `current_session/`. All iter-135
  substantive Lean-file changes came from the refactor subagent during
  the plan phase (see `task_results/refactor-grpobj-and-jacobian-iter135.md`).
- **Stage**: stays at `prover` for iter-136. Per
  `session_135/recommendations.md` HIGH, iter-136's PRIMARY ACTION is
  to dispatch a prover lane on
  `relativeDifferentialsPresheaf_restrict_along_identity_section`
  (~30–80 LOC, the smallest substantive piece of piece (i.b)) per
  PROGRESS.md watch criterion 4.

## Detail

### Iter-135 dispatch shape (plan phase, ratified by 3 critics)

- **Wave 1 (parallel)** — 3 critics + 1 mathlib-analogist:
  - `strategy-critic-iter135` → SOUND with 1 CHALLENGE
    (pre-stage piece (i.b) type-check spike) + 2 minor alternatives
    (Alt 1: genus-stratified body restructure NOW; Alt 2:
    temporary-axiom pile-composition smoke test ~iter-143). CHALLENGE 1
    ABSORBED by Wave-1 mathlib-analogist (D) `lean_run_code`
    elaboration check + Wave-2 refactor's actual landing. Alt 1
    ADOPTED as Wave-2 refactor Change 2.1. Alt 2 REJECTED-WITH-
    EXPLICIT-REBUTTAL (no-axioms iter-121 user directive; the
    iter-135 type-elaboration check already serves as a
    lighter-weight integration spike). Naming-wart edit
    `Ideal.IsLocalRing.CotangentSpace` → `IsLocalRing.CotangentSpace`
    ABSORBED via STRATEGY.md `replace_all`.
  - `blueprint-reviewer-iter135` → 5 chapters partial + 1 bonus orphan
    (`AlgebraicJacobian_Cotangent_GrpObj.tex` not `\input`-ed in
    `content.tex` — fixed via plan-agent direct edit). HARD GATE
    vacuous this iter (no prover lane).
  - `progress-critic-iter135` → 1 CONVERGING (Route 1) + 3 UNCLEAR
    (Routes 2, 3, 4 deferred-by-design or fresh; 0 CHURNING / 0
    STUCK). Route 4 (piece (i.b)) UNCLEAR with placeholder-pattern
    watch-flag; iter-135 corrective (refactor to honest scaffolds +
    analogist on φ morphisms + no prover lane this iter) explicitly
    endorsed.
  - `mathlib-analogist-phi-compatibility-morphisms-iter135` →
    PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN. (A) Critical:
    `schemeHomRingCompatibility` is WRONG SHAPE for
    `PresheafOfModules.pullback` — must use Mathlib's canonical
    `Scheme.Hom.toRingCatSheafHom` (ALIGN_WITH_MATHLIB
    must-fix-this-iter). (B) Literal Lean text for all 3 intended
    types provided. (C) No new project `def`s for `φ_*` — inline or
    `let`-binding only. (D) All 3 intended types ELABORATE CLEANLY
    via `lean_run_code`. Persistent file
    `analogies/phi-compatibility-morphisms.md` created.

- **Wave 2 (sequential per max_parallel=1, parallel-by-policy)** —
  1 refactor + 3 blueprint-writers:
  - `refactor-grpobj-and-jacobian-iter135` → COMPLETE (9 sub-changes;
    Lean side 575 → 573 LOC + 284 → 301 LOC; build green; no new
    axioms; 1 deviation: directive's `genus C.left` corrected to
    `genus C` per Application type mismatch on `genus`'s argument).
  - `blueprint-writer-rigiditykbar-iter135` → COMPLETE
    (560 → 586 LOC; new `lem:GrpObj_shearMulRight` block + proof
    sketch; streamlined `lem:GrpObj_mulRight_globalises` Step 1; 3
    iter-134 NOTE rewrites; 3 line-citation de-pins).
  - `blueprint-writer-mayervietoris-iter135` → COMPLETE (net 0 LOC;
    3 broken `\ref{...}`s fixed at L769 + L917).
  - `blueprint-writer-jacobian-iter135` → COMPLETE (new
    `\subsection{The positive-genus arm of the witness existence}` +
    `\lean{AlgebraicGeometry.positiveGenusWitness}` block + proof
    sketch; updated item (γ) prose + `thm:nonempty_jacobianWitness`
    proof body-restructure paragraph; de-pinned `genusZeroWitness`
    line citation).

- **Plan-agent direct edits** — 3 small edits (STRATEGY.md naming-wart
  `replace_all`; `content.tex` `\input{...}` for the orphan auxiliary
  chapter; auxiliary chapter bullet-list update for
  `schemeHomRingCompatibility` + `shearMulRight` `@[simps]`
  companions).

### Iter-135 dispatch shape (review phase)

- 3 review-phase subagents dispatched in parallel:
  - `lean-auditor-review135` (360s / $2.20 / 24 turns):
    - 13 files audited; 9 issues total.
    - 6 must-fix all load-bearing `:= sorry` bodies (3 iter-135
      honest replacements at `Cotangent/GrpObj.lean:468/496/560` + 3
      inherited from iter-126/127/134 at `RigidityKbar.lean:87` +
      `Jacobian.lean:197` + `Jacobian.lean:223`); each one documented
      as a scaffold with a named closure target and iter-aligned
      closure plan.
    - 0 excuse-comments. The audit specifically searched for the
      directive's listed patterns (`-- TODO replace`, `-- placeholder`,
      `-- temporary`, `-- wrong but works`, `-- will fix later`) and
      several variants — no matches in any project `.lean` file.
    - 0 major; 3 minor (4 documentation-rot "line N below" anchors
      inside `cotangentSpaceAtIdentity` docstring; verbose `_curve`
      wrapper-doubling pattern across `StructureSheafModuleK.lean` +
      `MayerVietorisCover.lean`).
    - **Overall verdict (verbatim)**: "the project's `.lean` source
      is internally consistent and the iter-135 refactor is a
      legitimate honesty improvement (3 typed lies replaced by 3
      honest scaffolds, 1 inline `sorry` decomposed into 2 delegations);
      the 6 outstanding load-bearing `:= sorry` bodies are the
      project's known mathematical-content scaffolds, all openly
      documented with iter-aligned closure plans rather than hidden
      behind excuse-comments."

  - `lean-vs-blueprint-checker-cotangent-grpobj-review135` (554s /
    $1.30 / 11 turns):
    - 8 `\lean{...}` blocks checked (7 mapped + 1 acknowledged
      `\notready` deferral for `cotangentSpaceAtIdentity_iso_localRingCotangent`).
    - 0 must-fix / 0 major / 1 minor: partial L61/L107/L146/L155/L160
      file-header line-anchor de-pinning (Change 1.6 in the iter-135
      refactor directive was only partially executed; 5 stale anchors
      remain — actual lines 256 / 210, not 244 / 198).
    - Coverage 7/7 substantive declarations + 1 packaging helper
      + 2 `@[simps]`-derived companions = adequate. Proof-sketch
      depth, hint precision, generality all "matches need".
    - **Overall verdict**: "this Lean file follows its blueprint
      chapter faithfully, the three honest-scaffold `sorry` bodies
      are the explicitly-authorized iter-135 pattern (intended-type
      signatures pinned, `\notready` markers correct, closure targets
      documented), the blueprint chapter is adequately detailed to
      have guided this file's formalisation".

  - `lean-vs-blueprint-checker-jacobian-review135` (705s / $1.03 /
    11 turns):
    - 14 declarations checked.
    - 0 must-fix / 0 major / 1 minor: stale line-range citation at
      `Jacobian.tex:400` cites `Jacobian.lean:120–126`, actual
      location is L134–140 (iter-135 line shifts pushed the
      declaration down by 14 lines).
    - **Overall verdict**: "the iter-135 plan-phase refactor (body
      restructure of `nonempty_jacobianWitness` via `by_cases`, plus
      the new `positiveGenusWitness` subsection and updated proof
      block) is faithful, well-documented, and bidirectionally
      consistent — Lean and blueprint match cleanly with only a
      single minor line-range drift on a prose citation."

### Substantive Lean-side changes (from refactor task result)

**`AlgebraicJacobian/Cotangent/GrpObj.lean` (575 → 573 LOC, net −2)**:

- **Change 1.6** — File-header docstring (L28–32): stale Lean-line
  anchors (`149` / `198` / `244`) replaced with declaration names
  ("below"). 6 → 5 lines.
- **Change 1.5** — `schemeHomRingCompatibility` docstring addendum
  (+6 lines): clarifies that this helper is NOT the φ for
  `PresheafOfModules.pullback`; per iter-135 mathlib-analogist
  verdict (A) ALIGN_WITH_MATHLIB must-fix-this-iter.
- **Change 1.4** — Section docstring at L421–447: 27-line iter-134
  "placeholder-apology" block REPLACED with ~17-line iter-135
  honest-scaffold docstring naming the 3 intended sheaf-level RHS
  targets and the `(Scheme.Hom.toRingCatSheafHom <morphism>).hom`
  idiom.
- **Changes 1.1 / 1.2 / 1.3** — 3 hollow placeholders REFACTORED to
  3 honest sorry-bodied scaffolds:
  - L468 `relativeDifferentialsPresheaf_basechange_along_proj_two`
    typed against `Scheme.relativeDifferentialsPresheaf (fst G G).left
    ≅ (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom
    (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom)`.
  - L496 `relativeDifferentialsPresheaf_restrict_along_identity_section`
    typed against 4-composed-pullback iso realising the section
    identity `pr_2 ∘ s = η_G ∘ π_G`.
  - L560 `mulRight_globalises_cotangent` typed against
    `Scheme.relativeDifferentialsPresheaf G.hom ≅ (PresheafOfModules.pullback
    (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
    ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom
    (CategoryTheory.CommaMorphism.left η[G])).hom).obj
    (Scheme.relativeDifferentialsPresheaf G.hom))`.
- **Import added**: `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`.

**`AlgebraicJacobian/Jacobian.lean` (284 → 301 LOC, net +17)**:

- **Change 2.1** — `nonempty_jacobianWitness` body restructure
  (per strategy-critic-iter135 Alternative 1 ADOPTED): replaced
  inline `:= sorry` with:
  ```lean
  by_cases h : genus C = 0
  · exact ⟨genusZeroWitness C h⟩
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩
  ```
  Signature preserved verbatim. **Architectural improvement, not
  a sorry elimination** — total sorry content under this declaration
  is unchanged (one inline `sorry` replaced by delegation to two
  pre-existing sorry-bodied scaffolds).
- **Changes 2.2 / 2.3 / 2.4** — docstring status updates on
  `genusZeroWitness`, `positiveGenusWitness`, `nonempty_jacobianWitness`
  reflecting the iter-135 body restructure.
- **Refactor caught directive typo**: directive's literal Lean
  snippet `AlgebraicGeometry.genus (k := k) C.left = 0` was corrected
  by the refactor to `genus C = 0` (per Lean's "Application type
  mismatch" diagnostic — `genus`'s argument is `Over (Spec (.of k))`,
  not `Scheme`).

### Blueprint-side changes (from 3 writer task results)

**`RigidityKbar.tex`** (560 → 586 LOC):

- New `\begin{lemma}\label{lem:GrpObj_shearMulRight}\lean{AlgebraicGeometry.GrpObj.shearMulRight}`
  block + proof sketch (the closed iter-134 Step 1 promoted from
  inline description to a dedicated block).
- Streamlined `lem:GrpObj_mulRight_globalises` Step 1 to a
  one-paragraph pointer to the new `shearMulRight` block.
- Rewrote 3 iter-134 NOTE blocks (lines 372–381, 452–462, 505–514)
  as iter-135 honest-scaffold resolution NOTEs citing
  `analogies/phi-compatibility-morphisms.md` +
  `Scheme.Hom.toRingCatSheafHom`.
- De-pinned 3 stale `Cotangent/GrpObj.lean:NNN` line citations.

**`Cohomology_MayerVietoris.tex`** (net 0 LOC):

- 3 broken `\ref{...}`s fixed at L769 (rephrased to drop 2
  non-existent `\ref{sec:basic_open_*}`s) and L917 (`def:` → `thm:`
  prefix to match the actual ModuleK label).

**`Jacobian.tex`**:

- New `\subsection{The positive-genus arm of the witness existence}`
  + `\lean{AlgebraicGeometry.positiveGenusWitness}` block + proof
  sketch documenting M3 routes + cost estimates (the new iter-134
  scaffold previously had no blueprint coverage).
- Updated item (γ) prose + `thm:nonempty_jacobianWitness` proof block
  iter-135 body-restructure paragraph.
- De-pinned `genusZeroWitness` line citation.

### Verification (refactor-side, plan-agent independent)

After the iter-135 refactor returned, the plan agent independently
re-ran:

- `mcp__archon-lean-lsp__lean_diagnostic_messages` on
  `Cotangent/GrpObj.lean` → 3 expected `declaration uses sorry`
  warnings on L468, L496, L560 (the 3 new honest scaffolds). No
  errors.
- `mcp__archon-lean-lsp__lean_diagnostic_messages` on `Jacobian.lean`
  → 2 expected `declaration uses sorry` warnings on L193, L219 (the
  unchanged `genusZeroWitness` + `positiveGenusWitness` scaffolds).
  The prior inline-sorry on `nonempty_jacobianWitness:236` is GONE.
  Plus 1 pre-existing long-line linter warning on L275 (unchanged;
  protected signature).
- `mcp__archon-lean-lsp__lean_verify` on
  `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` →
  `{propext, sorryAx, Classical.choice, Quot.sound}` (kernel + sorry,
  no new axioms).
- `mcp__archon-lean-lsp__lean_verify` on
  `AlgebraicGeometry.nonempty_jacobianWitness` → same axiom set
  (sorry transmitted through the two scaffold bodies).

The refactor's self-report matches the plan-agent + review-phase
independent verifications.

### Sorry-count delta verification

Per refactor task result + review-phase audits + per-file
`lean_diagnostic_messages` returns:

| File | Entering iter-135 | At iter-135 close | Delta |
|---|---|---|---|
| `Cotangent/GrpObj.lean` | 0 (3 hidden behind `Nonempty (X ≅ X) := ⟨Iso.refl _⟩`) | **3** (3 NEW honest scaffolds) | +3 net signal |
| `Jacobian.lean` | 3 | **2** | −1 |
| `RigidityKbar.lean` | 1 | **1** | 0 |
| **Total** | **4** | **6** | **+2** |

**Net semantic-health delta: materially positive.** The 4 → 6 count
increase reflects (a) 3 placeholder-pattern declarations becoming
machine-readable as incomplete (which they always were, but
`sorry_analyzer` could not detect when the body was `⟨Iso.refl _⟩`);
and (b) 1 inline-`sorry` site converting to structural decomposition
over named scaffolds. The `sorry_analyzer` and `lean_verify` outputs
are now honest signals; before iter-135, they undercounted the actual
work remaining on piece (i.b).

### Blueprint marker updates (manual, this review phase)

(none in the review phase)

Rationale: the iter-135 plan-phase blueprint-writers handled all NOTE
block rewrites, `\notready` retention, `\lean{...}` hint additions,
and `\ref{...}` fixes per their writer-domain authority. Deterministic
`sync_leanok` manages `\leanok`. There are no `\mathlibok` candidates
this iter (the 3 new honest scaffolds are project-internal
NEEDS_MATHLIB_GAP_FILL contribution candidates, not Mathlib
re-exports), no `\lean{...}` renames flagged in any task_result, no
`\notready` strips warranted.

**Note on stale `\leanok` markers** (carried forward from plan.md
watch criterion 6 to recommendations.md MED-A): 3 `\leanok` markers
on the proof blocks of `lem:GrpObj_mulRight_globalises`
(`RigidityKbar.tex:402`), `lem:GrpObj_omega_basechange_proj` (L473),
and `lem:GrpObj_omega_restrict_to_identity_section` (L524) are STALE
post-iter-135 refactor. These were added by `sync_leanok` after the
iter-134 prover lane shipped `⟨Iso.refl _⟩` bodies; iter-135's
refactor swapped those bodies for `:= sorry`, but `sync_leanok` did
NOT re-run this iter (no prover phase → no sync trigger). Per the
review prompt rules ("Do not add or remove `\leanok` yourself"), the
review agent leaves these markers in place; they will be removed by
the next `sync_leanok` run.

### META-PATTERN TRIPWIRE status

The iter-132 META-PATTERN TRIPWIRE non-promise commitment (no 4th
body reshape on `cotangentSpaceAtIdentity`) **HOLDS** this iter. The
Wave-2 refactor did not touch `cotangentSpaceAtIdentity`,
`cotangentSpaceAtIdentity_eq_extendScalars`, or
`cotangentSpaceAtIdentity_finrank_eq` (piece (i.a) declarations
DONE iter-132). Refactor edits to `Cotangent/GrpObj.lean` were
confined to the iter-134 placeholder section + the file-header
docstring + the `schemeHomRingCompatibility` docstring addendum.

### Iter-135 progress-critic PASS criterion (verified)

Iter-135 progress-critic's PASS criterion was: "≥ 2 of 3
placeholders refactored to non-`Nonempty (X ≅ X)` types". Iter-135
refactor refactored **3 of 3** — fully satisfied (over-satisfying).
Route 4 (piece (i.b)) is on track for iter-136 prover lane against
the honest scaffolds.

### Trigger (a')/(c) LOC arm status

NOT FIRED (per `strategy-critic-iter134` CHALLENGE 1's 600-LOC arm).
Iter-135 added 0 LOC to (i.b)-side build (the refactor was a
signature change, not new pile build). Iter-136+ accumulates against
this arm as Steps 3 / 2 / Compose close.

## Stage and next iter

- **Stage**: stays at `prover` for iter-136.
- **iter-136 PRIMARY ACTION** (per `session_135/recommendations.md`
  HIGH): dispatch a prover lane on
  `AlgebraicJacobian/Cotangent/GrpObj.lean` targeting
  `relativeDifferentialsPresheaf_restrict_along_identity_section`
  at L496 (piece (i.b) Step 3, ~30–80 LOC closure via
  `PresheafOfModules.pullbackComp` + `PresheafOfModules.pullbackId`).
  Per PROGRESS.md watch criterion 4: Step 3 first, then Step 2 (if
  Step 3 closes within iter-136), then composition into the main
  lemma. If iter-136 stalls on Step 3, escalate via blueprint-writer
  expansion before assigning iter-137 prover lane.
- **iter-136 mandatory dispatches**: 3 critics +
  `lean-vs-blueprint-checker` for each iter-136-prover-touched file.

## Pointers

- Full session journal: `proof-journal/sessions/session_135/{summary.md, milestones.jsonl, recommendations.md}`
- Plan-phase narrative: `iter/iter-135/plan.md`
- Review-phase audit reports: `task_results/lean-auditor-review135.md`,
  `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review135.md`,
  `task_results/lean-vs-blueprint-checker-jacobian-review135.md`
- Plan-phase subagent reports: 6 reports in `task_results/` + mirrored
  at `.archon/logs/iter-135/{name}-{slug}-report.md`.
