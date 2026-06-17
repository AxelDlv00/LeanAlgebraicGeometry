# Iter-136 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED on piece (i.b) Step 3** for
  `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`
  at `AlgebraicJacobian/Cotangent/GrpObj.lean:496` (now L508 post-iter-136).
  `meta.json`: `planValidate.status: ok`, `prover.status: done`,
  `prover.durationSecs: 1523` (~25 min). The lane added 2 declarations to
  the file (574 → 612 LOC; +38 LOC including ~11 LOC of docstring updates +
  the new ~5 LOC private helper + the ~22 LOC body): a new private helper
  `section_snd_eq_identity_struct` (L452, captures the categorical identity
  `s.left ≫ pr_2.left = G.hom ≫ η[G].left` via `Over.comp_left` +
  `lift_snd` + `Over.toUnit_left` + trailing `rfl`), and the substantive
  body of `relativeDifferentialsPresheaf_restrict_along_identity_section`
  itself (L508–L551, using `PresheafOfModules.pullbackComp` on both sides
  then `change` to reshape both into single-pullback form via the c-
  composition rule, then `rw [section_snd_eq_identity_struct]`).
- **Sorry count delta**: 6 → **5** (−1 substantive close). Per-file at
  iter-136 close (verified by `grep -E '(:= sorry|^\s*sorry\b|by sorry)'`):
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:488` —
    `relativeDifferentialsPresheaf_basechange_along_proj_two`
    (Step 2 honest scaffold; iter-137 target).
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:610` —
    `mulRight_globalises_cotangent` (Main; iter-138+ target after Step 2).
  - `AlgebraicJacobian/Jacobian.lean:197` — `genusZeroWitness`
    (M2.b iter-153–156 schedule; unchanged).
  - `AlgebraicJacobian/Jacobian.lean:223` — `positiveGenusWitness`
    (M3 user-escalation-gated; unchanged).
  - `AlgebraicJacobian/RigidityKbar.lean:87` — `rigidity_over_kbar`
    (M2.b body-pile-gated; unchanged).
- **2 mandatory review-phase audits dispatched + returned, both clean**:
  - `lean-auditor-review136` (264 s / $2.37 / 22 turns; 13 files audited):
    **0 must-fix / 0 major / 0 excuse-comments / 3 minor**. All 3 minors
    are docstring drift in `Cotangent/GrpObj.lean` from iter-136 — the
    file-internal references to the iter-136 closure (L506 "below" →
    "above" on the consumer; L596–L597 "Steps 2 and 3" → "Step 2" on
    `mulRight_globalises_cotangent`'s status line; L427–L432 section
    header "Bodies are `sorry` — closure is iter-136+" → "Bodies of Step
    2 and the main lemma remain `sorry`; Step 3 closed iter-136"). The
    iter-136 body itself is "honest, surgical, and free of excuse-
    comments." See `task_results/lean-auditor-review136.md`.
  - `lean-vs-blueprint-checker-cotangent-grpobj-review136` (457 s /
    $1.70 / 13 turns; single file ↔ single chapter):
    **0 must-fix / 0 major / 2 minor**. 7 `\lean{…}`-tagged declarations
    cross-checked — all signatures match blueprint pinning; 5
    substantively closed; 2 remaining sorry-scaffolds correctly carry
    `\notready`. Iter-136 closure of `_restrict_along_identity_section`
    "faithfully implements blueprint L527–L528" via
    `PresheafOfModules.pullbackComp` + categorical-identity recipe.
    Minors: (1) iter-135 MED-C carry-over — file-header line-anchor drift
    at L61/L107/L146/L155/L160 (stale "line 198/244"; iter-136 extended
    drift by ~+12); (2) optional preventive — one-line `% NOTE` near
    blueprint L490 distinguishing `schemeHomRingCompatibility` from the
    `toRingCatSheafHom`-route. Blueprint adequacy verdict: **adequate**
    (5/5 substantive coverage; precise hint precision; matches need).
    See `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review136.md`.

- **Compile-verified**: yes. `lean_diagnostic_messages` on
  `Cotangent/GrpObj.lean` returns 2 expected `declaration uses sorry`
  warnings (L488 + L610 — the two remaining iter-137+/iter-138+ targets)
  and 0 errors. `lake env lean AlgebraicJacobian/Cotangent/GrpObj.lean`
  green. `lean_verify
  AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`
  returns `{propext, Classical.choice, Quot.sound}` — kernel-only, no
  `sorryAx`, no project axioms.
- **No new axioms**. `archon-protected.yaml` unchanged (9 protected
  declarations). The new private helper is project-internal and uses
  only `Over.comp_left` / `lift_snd` / `Over.toUnit_left` plus a final
  `rfl`; the body uses `PresheafOfModules.pullbackComp` +
  `Scheme.Hom.toRingCatSheafHom` + `change` + a single `rw` — all
  Mathlib idioms.
- **`current_session/attempts_raw.jsonl` is fresh** (127 events,
  timestamps 2026-05-18T01:16–01:42Z, matching prover stage start at
  2026-05-18T00:50:45Z). 28 edits + 8 goal checks + 21 diagnostic
  checks + 2 lemma searches + 0 builds + 14 total errors (across
  intermediate attempts) + 0 clean-diagnostics final. Single file
  edited (`Cotangent/GrpObj.lean`); 9 Mathlib files read during
  pattern-discovery for the `Opens.map_comp_eq` /
  `pullbackPushforwardAdjunction` / `pullbackComp` / `comp_c`
  investigation. No stale-artefact drift recurrence.

## Per-route status after iter-136

| Route | File | Verdict pre iter-136 | Verdict post iter-136 | Change |
|---|---|---|---|---|
| Route 1 (piece (i.a)) | `Cotangent/GrpObj.lean` (closed decls) | CONVERGING | CONVERGING | none — META-PATTERN TRIPWIRE non-promise held; no piece-(i.a) declaration touched this iter. |
| Route 2 (M2.b genus-0 arm) | `Jacobian.lean:197` (`genusZeroWitness`) | UNCLEAR-by-design | UNCLEAR-by-design | no movement — gated on M2.b body close iter-153–156; off-limits iter-137. |
| Route 3 (M2.b body-pile) | `RigidityKbar.lean:87` (`rigidity_over_kbar`) | UNCLEAR-by-design | UNCLEAR-by-design | no movement — gated on body-pile assembly. |
| Route 4 (piece (i.b)) | `Cotangent/GrpObj.lean:488/610` (Step 2 + Main) | UNCLEAR (leaning CONVERGING; 2 iters of substantive data) | **CONVERGING** | flip — iter-135's next-tier PASS criterion ("substantively close ≥ 1 of 3 honest-scaffold bodies in iter-136") fully satisfied. Step 3 closed substantively at ~27 LOC, kernel-only axioms, both audits clean. Step 2 (L488, ~150–300 LOC NEEDS_MATHLIB_GAP_FILL via `KaehlerDifferential.tensorKaehlerEquiv`) is iter-137 target; Main (L610, ~20–40 LOC composition) is iter-138+ target. |

0 routes CHURNING; 0 routes STUCK; 0 routes triggering the iter-134
TRIPWIRE (`Nonempty (X ≅ X) := ⟨Iso.refl _⟩` anti-pattern) — the
iter-136 body is honestly typed and substantively constructed.

## Iter-135 carry-forward items (status check)

- **Iter-135 progress-critic next-tier PASS** (≥ 1 of 3 honest-scaffold
  bodies substantively closed iter-136): **SATISFIED** (1 of 3 closed,
  in budget at ~27 LOC).
- **META-PATTERN TRIPWIRE** (iter-132 non-promise: no 4th body reshape
  on `cotangentSpaceAtIdentity`): **HELD** — iter-136 lane did not touch
  piece-(i.a) declarations.
- **Trigger (a')/(c) LOC arm** (`strategy-critic-iter134` CHALLENGE 1;
  > 600 LOC of (i.b)-side build without converging): cumulative
  iter-134→iter-136 build on (i.b) is ~316 LOC (296 → 612), well inside
  envelope. Iter-137 budget for Step 2 (~150–300 LOC) brings cumulative
  to ~466–616 LOC, still within envelope; iter-138+ closure of the Main
  composition (~20–40 LOC) lands safely under 600 LOC.
- **Iter-135 deferred docstring-rot items** (4 "line N below" references
  inside `cotangentSpaceAtIdentity` docstring at L61/L107/L146/L155/L160;
  iter-135 lean-vs-blueprint-checker MED-C): **drift extended modestly
  this iter** (~+12 lines) per `lean-vs-blueprint-checker-cotangent-grpobj-review136`
  minor #1. Iter-137 refactor bundle recommended (see `recommendations.md`
  MED-B; 6 sites total counting the 3 iter-136-introduced docstring drifts).
- **Stale `\leanok` markers** (iter-135 MED-A; iter-134 placeholder bodies
  had `\leanok` added by `sync_leanok`, which iter-135 refactor would
  have removed by re-run, except no prover ran iter-135): the `\leanok`
  on the proof block of `lem:GrpObj_omega_restrict_to_identity_section`
  at `RigidityKbar.tex:524` was added iter-134 and was stale through
  iter-135 (body was `sorry`); is now **actually correct** post-iter-136
  because the body was substantively closed. `sync_leanok` re-running
  after iter-136 review-phase will preserve it. The `\leanok`s on the
  other two sibling lemmas' proof blocks (`lem:GrpObj_omega_basechange_proj`
  at L473 and `lem:GrpObj_mulRight_globalises` at L402) remain stale
  (those bodies are still `sorry`); `sync_leanok` will remove them.

## Subagent dispatches this iter

Plan-phase: 3 mandatory critics (`strategy-critic-iter136` SOUND with
2 CHALLENGEs absorbed + 1 minor alternative rebutted with scope note;
`blueprint-reviewer-iter136` HARD GATE CLEAR after a 2-char
plan-agent direct edit; `progress-critic-iter136` UNCLEAR-leaning-
CONVERGING; 0 CHURNING / 0 STUCK). Plan-agent direct edits: 3
(blueprint case-fix `\ref{chap:rigidity_kbar}` → `chap:RigidityKbar`
in `AlgebraicJacobian_Cotangent_GrpObj.tex`; 2 STRATEGY.md edits per
the critic absorption). See `iter/iter-136/plan.md` for full detail.

Review-phase: 2 mandatory review subagents (this iter), both returned
**0 must-fix / 0 major / N minor**:

| Subagent | Slug | Cost | Duration | Verdict |
|---|---|---|---|---|
| `lean-auditor` | review136 | $2.37 | 264 s | **CLEAN.** 13 files, 0 must-fix / 0 major / 0 excuse-comments / 3 minor (all docstring drift in `Cotangent/GrpObj.lean`). |
| `lean-vs-blueprint-checker` | cotangent-grpobj-review136 | $1.70 | 457 s | **CLEAN.** 0 must-fix / 0 major / 2 minor (iter-135 carry-over line-anchor drift extended ~+12 lines; optional preventive blueprint note). |

Total review-phase cost: $4.07 / ~12 min (sequential under
`max_parallel: 1`).

## Manual blueprint marker changes this iter

- `blueprint/src/chapters/RigidityKbar.tex`,
  `lem:GrpObj_omega_restrict_to_identity_section` (statement block,
  L515): **stripped `\notready`** — Lean target now substantively
  closed (kernel-only axioms via `lean_verify`).
- Same chapter, same lemma's NOTE block at L505–L514: rewrote
  iter-135 NOTE ("ships as honest sorry-bodied scaffold; body is
  `sorry`; iter-136+ work") in-place to reflect iter-136 closure
  (described as "now substantively closed (no `sorry`; kernel-only
  axioms)" with the new private helper `section_snd_eq_identity_struct`
  named, the ~27 LOC actual envelope vs predicted ~30–80, and the
  `change`-based reshape technique highlighted). The iter-135 NOTE is
  no longer accurate and has been retired.

No other manual marker changes:
- No new `\mathlibok` candidates (iter-136 declaration is
  project-internal).
- No `\lean{...}` renames flagged.
- The other two sibling lemmas at L463 (`_basechange_along_proj_two`)
  and L382 (`mulRight_globalises_cotangent`) correctly retain
  `\notready` — bodies still `sorry` per iter-137+/iter-138+ schedule.

## Knowledge Base additions queued for PROJECT_STATUS.md

Three short codification-worthy patterns surfaced by the iter-136
closure (added to PROJECT_STATUS.md Knowledge Base this review phase):

1. **`change` over `show` for definitional-equality carrier reshapes**
   when the syntactic form differs but the semantic form is
   definitional. The Lean linter warns on `show` for genuine shape
   changes; `change` is the idiomatic vehicle. Specifically: the
   combined compatibility morphism produced by
   `PresheafOfModules.pullbackComp` is **definitionally equal** to
   `(Scheme.Hom.toRingCatSheafHom (composite)).hom` (via `Scheme.Hom.c`
   of a composition + `whiskerRight` over `whiskerLeft`); `change`
   accepts the reshape without rewriting, reducing the iso-equality to
   a pure scheme-morphism equality.

2. **`refine iso1 ≪≫ ?_ ≪≫ iso2.symm`** as the iso-equivalent of
   `refine ... ≫ ?_ ≫ ...` — the `.trans` API does **not** accept the
   literal `sorry` token in chained position (`«sorry».trans` parse
   error: "Unknown identifier `«sorry».trans`"). The `≪≫` notation +
   `refine` is the clean Mathlib alternative when you need a hole in
   the middle of an iso composition.

3. **Canonical-section identity in `Over (Spec k)` for `GrpObj G`**:
   `s.left ≫ pr_2.left = G.hom ≫ η[G].left` (where
   `s := lift (𝟙 G) (toUnit G ≫ η[G])`) is provable in ~5 LOC via
   `rw [← Over.comp_left, lift_snd, Over.comp_left, Over.toUnit_left];
   rfl`. The trailing `rfl` is **load-bearing** — it bridges
   `CommaMorphism.left η[G]` (human-named, displayed in docstrings)
   vs Lean's auto-elaborated `η.left`. These are equal but not
   syntactically identical to `rw`.

## TO_USER.md status

Left **empty** this iter. No impasse:
- The iter-136 prover lane closed substantively, kernel-only.
- Both review audits returned 0 must-fix / 0 major.
- Route 4 (piece (i.b)) flipped UNCLEAR → CONVERGING; iter-137
  proceeds routinely on Step 2.
- The iter-136 plan agent's rebuttal of the
  `strategy-critic-iter136` partial-result-shipping minor alternative
  recorded the future TO_USER consultation as iter-151+ when M2
  closure is concrete — not iter-136 work.

## Iter-137 staged scope (see `recommendations.md` for full detail)

- **HIGH-PRIMARY**: prover lane on
  `relativeDifferentialsPresheaf_basechange_along_proj_two` at
  `Cotangent/GrpObj.lean:488` (~150–300 LOC NEEDS_MATHLIB_GAP_FILL
  via `KaehlerDifferential.tensorKaehlerEquiv` chain).
- **HIGH-mandatory**: 3 plan-phase critics (strategy / blueprint-
  reviewer / progress) per standard.
- **HIGH-mandatory** (review-phase): `lean-auditor` + `lean-vs-
  blueprint-checker-cotangent-grpobj` per prover-touched file rule.
- **MED-A**: optional pre-dispatch `mathlib-analogist` on the
  `KaehlerDifferential.tensorKaehlerEquiv` ↔ `PresheafOfModules.pullback`
  bridge (de-risks Step 2 the same way iter-135 analogist de-risked
  Step 3). Persistent file
  `analogies/kaehler-tensorequiv-presheafpullback.md`.
- **MED-B**: small refactor lane bundling 6 docstring-drift sites in
  `Cotangent/GrpObj.lean` (3 iter-136-introduced + 3 file-header
  line-anchor sites from iter-135 MED-C carry-over).
- **MED-C**: optional 1-line blueprint `% NOTE` near
  `RigidityKbar.tex:490` distinguishing `schemeHomRingCompatibility`
  from the `toRingCatSheafHom`-route.

## meta.json summary

```
iteration: 136
stage: prover
mode: parallel
planValidate.status: ok / objectives: 1
plan.durationSecs: 1543 (~26 min)
prover.durationSecs: 1523 (~25 min)
prover.status: done
provers: 1 (AlgebraicJacobian_Cotangent_GrpObj — done)
```
