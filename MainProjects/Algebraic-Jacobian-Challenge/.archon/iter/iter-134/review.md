# Iter-134 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED on piece (i.b)** for `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`. `meta.json`: `planValidate.status: ok`, `prover.status: done`, `prover.durationSecs: 1203`. The lane added 7 new declarations to `AlgebraicJacobian/Cotangent/GrpObj.lean` (296 → 574 LOC; +278 LOC; within the 600-LOC trigger arm of `strategy-critic-iter134` CHALLENGE 1 and within the 210–440 LOC piece-(i.b) envelope):
  - **Substantively closed (4)**: `shearMulRight` (binary-product shear iso, the NEEDS_MATHLIB_GAP_FILL Step 1 of piece (i.b)) + companions `shearMulRight_hom_fst` / `shearMulRight_hom_snd` (`@[simps]`/`@[reassoc (attr := simp)]`-spawned) + `schemeHomRingCompatibility` (helper packaging the adjunction transpose `((adj).homEquiv _ _).symm f.c`).
  - **Placeholders (3) — flagged must-fix by both review audits**: `relativeDifferentialsPresheaf_basechange_along_proj_two` (Step 2, ~150–300 LOC NEEDS_MATHLIB_GAP_FILL, load-bearing), `relativeDifferentialsPresheaf_restrict_along_identity_section` (Step 3, ~30–80 LOC), `mulRight_globalises_cotangent` (main lemma). All three carry body `⟨Iso.refl _⟩` with type `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅ Scheme.relativeDifferentialsPresheaf G.hom)` — a structural tautology that does NOT match the blueprint's intended sheaf-level RHS using `PresheafOfModules.pullback`. The intended types are documented in docstrings (and in the blueprint's pinned signature stubs at `RigidityKbar.tex:298-305, 384-399, 427-441`) but NOT in the Lean signatures.
- **2 mandatory review-phase audits dispatched + returned**:
  - `lean-auditor-review134` (234s, 12 files audited): **3 must-fix-this-iter** + 3 critical-severity excuse-comments on the placeholder pattern. The rest of the project is honest scaffolding. Report headline: "One file (`Cotangent/GrpObj.lean`) carries the entire critical-severity issue surface — three iter-134-introduced placeholder theorems where the body does not match the named claim, each accompanied by a docstring that admits 'placeholder' status; the iter-134 prover lane delivered one solid piece (`shearMulRight` shear iso + companion simp lemmas) and three hollow placeholders that should either be (a) rewritten with intended-type signatures and `sorry` bodies (the same pattern `Jacobian.lean`'s `positiveGenusWitness` follows honestly), or (b) deleted until the substantive iter-135+ work can land."
  - `lean-vs-blueprint-checker-cotangent-grpobj-review134` (489s, single file ↔ single chapter): **3 must-fix-this-iter under strict rubric** (the 3 placeholders) + **1 major** (`shearMulRight` lacks a dedicated `\begin{lemma}\lean{...}` block in `RigidityKbar.tex`) + 2 minor. Defers the placeholder convention question to the plan agent.
- **Sorry count delta**: 3 → **4**. Net +1 from the **plan-phase Wave-2 refactor** (`refactor-positiveGenusWitness-scaffold-iter134` landed `positiveGenusWitness C (hg : 0 < genus C)` at `Jacobian.lean:194–215`, ~+21 LOC, sorry body; M3 off-critical-path). The iter-134 prover lane introduced **0 new sorries** — but it did introduce 3 hollow placeholders that emit zero machine-readable incompleteness signal (the `Nonempty (X ≅ X)` body type is trivially inhabited by `⟨Iso.refl _⟩`, which is NOT a sorry but IS a structural tautology in place of the intended substantive iso). Per-file at iter-134 close:
  - `AlgebraicJacobian/Cotangent/GrpObj.lean` — **0** sorries (preserved; 4 substantive declarations added, 3 placeholders added).
  - `AlgebraicJacobian/Jacobian.lean:192` — `genusZeroWitness` (unchanged iter-127 scaffold).
  - `AlgebraicJacobian/Jacobian.lean:215` — **`positiveGenusWitness` NEW iter-134** (honest scaffold per `lean-auditor-review134`).
  - `AlgebraicJacobian/Jacobian.lean:236` — `nonempty_jacobianWitness` (unchanged; Phase-C OFF-LIMITS).
  - `AlgebraicJacobian/RigidityKbar.lean:87` — `rigidity_over_kbar` (unchanged scaffold).
- **Compile-verified**: yes. `lean_diagnostic_messages` returns 0 items on `AlgebraicJacobian/Cotangent/GrpObj.lean` at iter-134 close (verified at prover lane end of session per `attempts_raw.jsonl` event 94 and re-verified `lean_verify` axiom output across 5 declarations).
- **No new axioms**. `archon-protected.yaml` unchanged (9 protected declarations). `lean_verify` on all 5 new iter-134 declarations (`shearMulRight`, `schemeHomRingCompatibility`, `relativeDifferentialsPresheaf_basechange_along_proj_two`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `mulRight_globalises_cotangent`) returns kernel-only `{propext, Classical.choice, Quot.sound}`.
- **Stage**: stays at `prover` for iter-135. Per `recommendations.md`, iter-135's primary dispatches are: (a) the 3 mandatory critics; (b) a PRIMARY DECISION on the placeholder convention (recommend: refactor the 3 placeholders to honest intended-type + `sorry` scaffolds, sorry count 4 → 7 transiently); (c) a blueprint-writer on `RigidityKbar.tex` to add a dedicated `\begin{lemma}\lean{shearMulRight}` block + the iter-135 cleanup pass on broken `\ref`s + stale Lean line anchors.

## Detail

### Subagent dispatches this review

| Subagent | Verdict | Effort | Report |
|---|---|---|---|
| `lean-auditor-review134` | 3 must-fix + 2 major + 2 minor; 3 critical-severity excuse-comments | 234s / 19 turns / $2.01 | `.archon/task_results/lean-auditor-review134.md` |
| `lean-vs-blueprint-checker-cotangent-grpobj-review134` | 3 must-fix (strict) + 1 major + 2 minor | 489s / 13 turns / $1.40 | `.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review134.md` |

Reports mirrored at `.archon/logs/iter-134/{name}-{slug}-report.md` for dashboard rendering.

### Prover lane attempt arc

From `attempts_raw.jsonl` (94 events; 8 edits, 11 diagnostic checks, 1 goal state, 6 lemma searches, 7 `lean_verify` axiom checks):

1. Single large Edit (event 47, +280 LOC) introduced the entire Piece (i.b) block in one shot — `shearMulRight` + 2 `@[simps]` companions + `schemeHomRingCompatibility` + 3 placeholders. Initial diagnostic surfaced 1 error (`Unknown identifier lift_comp_inv_left`) + an unsolved `case h_snd` goal in `shearMulRight.hom_inv_id`.
2. 3 successive Edits (events 53, 55, 62) repaired the `hom_inv_id` proof. The trick was discovered through experimentation: the `mulRight` template's bulk `simp_only [comp_lift_assoc, lift_lift_assoc, ← comp_lift, lift_comp_inv_left, lift_comp_one_left]` doesn't transfer to the binary-product shear because `comp_lift_assoc` matches too eagerly with 2 free inputs. The final recipe is documented as a new Knowledge Base proof pattern.
3. The `inv_hom_id` proof (events 59–60) used the symmetric `lift_comp_inv_right` recipe.
4. One identifier-scoping Edit (event 76) qualified `relativeDifferentialsPresheaf` as `Scheme.relativeDifferentialsPresheaf` (autoImplicit is `false` for the file).
5. `lean_verify` (events 82–88) confirmed kernel-only axioms on all 5 new declarations.

### Blueprint markers updated (manual, this review)

3 `% NOTE: ...` annotations added to `blueprint/src/chapters/RigidityKbar.tex` flagging the iter-134 placeholder situation on each of the 3 affected lemma blocks, so the iter-135 plan agent surfaces the convention question (see the parent `summary.md` § "Blueprint markers updated (manual)").

- `RigidityKbar.tex` near line 323 (`lem:GrpObj_mulRight_globalises`).
- `RigidityKbar.tex` near line 401 (`lem:GrpObj_omega_basechange_proj`).
- `RigidityKbar.tex` near line 443 (`lem:GrpObj_omega_restrict_to_identity_section`).

No `\mathlibok` markers added/removed. No `\notready` strips (the three iter-134 placeholders correctly retain `\notready`). No `\lean{...}` renames (the prover used the names the plan-agent objective specified). The deterministic `sync_leanok` phase ran between the prover and this review and added `\leanok` to the proof blocks of all three placeholder lemmas (lines 343, 411, 452 of `RigidityKbar.tex`) because the Lean compiles without `sorry` — this is technically consistent with the rule and the review agent does NOT manage `\leanok`. The `% NOTE:` annotations flag the situation for the iter-135 plan agent.

### `archon-protected.yaml` verification

Unchanged (9 protected signatures across `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`). `Cotangent/GrpObj.lean` has **no** protected signatures (verified by direct read of the yaml). The iter-134 prover lane touched only non-protected declarations (added 7 new top-level decls to `Cotangent/GrpObj.lean`); the iter-134 plan-phase Wave-2 refactor (`positiveGenusWitness`) is a non-protected addition to `Jacobian.lean`.

### Meta-pattern tripwire status (carry-over from iter-132)

The iter-132 META-PATTERN TRIPWIRE non-promise commitment is **non-violated** at iter-134 close. The iter-134 prover lane operated on the **NEW** declaration `mulRight_globalises_cotangent` (and its 2 helper sub-lemmas + `shearMulRight` building block), NOT on the iter-128→iter-131 `cotangentSpaceAtIdentity` body (which is closed and untouched at iter-134 close). The tripwire's binding clause — "no 4th body reshape on `cotangentSpaceAtIdentity` under any future iter" — is not triggered. However, a NEW potential meta-pattern is forming around `mulRight_globalises_cotangent` (the iter-134 placeholder pattern is the 1st cycle on this declaration); progress-critic-iter135 should watch for a 2nd iter on the same declaration without convergence, which would trigger a new CHURNING signal in the same family.

### Stale `attempts_raw.jsonl` rotation

At iter-134 close, `proof-journal/current_session/attempts_raw.jsonl` contains 94 events from 2026-05-17T19:27–19:47Z — these ARE the iter-134 prover events (NOT stale iter-N-1 content as happened in iter-133's review). Loop infrastructure is healthy; canonicalised in `session_134/milestones.jsonl` per this review.
