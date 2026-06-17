# Iter-135 (Archon canonical) plan-agent run

## Headline outcome

Iter-134 prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean` for
piece (i.b) delivered:

- **Step 1 substantively closed**: `shearMulRight` (binary-product shear iso)
  + 2 `@[simps]` companions + helper `schemeHomRingCompatibility`.
  ~50 LOC honest closure, kernel-only axioms.

- **Steps 2 / 3 / Main (load-bearing)**: 3 **hollow placeholder theorems**
  typed `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅
  Scheme.relativeDifferentialsPresheaf G.hom)` with body `⟨Iso.refl _⟩`.
  Intended sheaf-level RHS types live only in docstrings. Both
  iter-134 review-phase audits classified this as **must-fix-this-iter
  under the strict rubric**.

**Iter-135 PRIMARY DECISION** (executed this iter): refactor the 3
placeholder theorems to the `positiveGenusWitness`-style honest scaffold
pattern — intended-type signatures with `sorry` bodies. Plus (per
strategy-critic-iter135 Alternative 1, ADOPTED): restructure
`nonempty_jacobianWitness` body from inline `:= sorry` to `by_cases h :
genus C = 0` delegating to `genusZeroWitness` + `positiveGenusWitness`.

**Iter-135 is plan-only refactor + writer iter** (NO prover lane this iter).
The 3 mandatory critics + 1 mathlib-analogist (Wave 1) cleared the
refactor design; the refactor + 3 blueprint writers (Wave 2) landed it.
Iter-136 prover lane attacks the honest sorry-bodied scaffolds on
stable signatures.

## Subagent dispatches this iter (6 total)

| Wave | Subagent | Slug | Verdict | Outcome |
|---|---|---|---|---|
| 1 (parallel) | `strategy-critic` | iter135 | **SOUND** with 1 CHALLENGE + 2 minor alternatives (8 routes audited; 0 REJECT) | CHALLENGE 1 (pre-stage piece (i.b) type-check spike) **ABSORBED** by Wave-1 analogist's `lean_run_code` elaboration check + Wave-2 refactor's actual landing. Alt 1 (genus-stratified body restructure now) **ADOPTED** as refactor Change 2.1. Alt 2 (temporary-axiom pile-composition smoke test) **REJECTED-WITH-REBUTTAL** (see § Rebuttal to strategy-critic Alt 2). Naming wart `Ideal.IsLocalRing.CotangentSpace` → `IsLocalRing.CotangentSpace` **ABSORBED** via `replace_all` edit on STRATEGY.md. |
| 1 (parallel) | `blueprint-reviewer` | iter135 | **5 chapters partial + 1 bonus orphan finding**; HARD GATE vacuous this iter | 5 chapter writer dispatches initially planned → reduced to 3 + 1 plan-agent direct edit + 1 dropped (ModuleK label-prefix asymmetry left as-is per smaller-blast-radius option (b); only the MV side ref updated). Bonus orphan finding (`AlgebraicJacobian_Cotangent_GrpObj.tex` not `\input`ed in `content.tex`) absorbed via plan-agent direct edit on `content.tex` + a small bullet-list update on the orphan chapter itself. |
| 1 (parallel) | `progress-critic` | iter135 | **1 CONVERGING + 3 UNCLEAR; 0 CHURNING / 0 STUCK** | Route 4 UNCLEAR with placeholder-pattern watch-flag; iter-135 corrective explicitly endorsed. Concrete iter-136 PASS criterion (≥ 2 of 3 placeholders to non-`Nonempty (X ≅ X)` types) **fully satisfied by Wave-2 refactor** (all 3 of 3 typed against `PresheafOfModules.pullback`-based intended RHS). |
| 1 (parallel) | `mathlib-analogist` | phi-compatibility-morphisms-iter135 | **PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN** (4 decisions, 2 ALIGN_WITH_MATHLIB) | (A) CRITICAL: `schemeHomRingCompatibility` is WRONG SHAPE for `PresheafOfModules.pullback`; use Mathlib's `Scheme.Hom.toRingCatSheafHom`. (B) Literal Lean text for all 3 intended types provided. (C) No new project `def`s for `φ_*`. (D) All 3 elaborate cleanly via `lean_run_code`. Persistent file `analogies/phi-compatibility-morphisms.md` created. |
| 2 (sequential, parallel-by-policy) | `refactor` | grpobj-and-jacobian-iter135 | **COMPLETE**, all 9 sub-changes; build green | 3 hollow placeholders → 3 honest sorry-bodied scaffolds using `Scheme.Hom.toRingCatSheafHom`; `nonempty_jacobianWitness` body → `by_cases` delegation; 6 docstring updates; 1 new import; 1 minor deviation (corrected directive's `genus C.left` typo to `genus C`). 4 → 6 project sorries; no new axioms. |
| 2 (sequential) | `blueprint-writer` | rigiditykbar-iter135 | **COMPLETE** (560 → 586 LOC) | New `lem:GrpObj_shearMulRight` block + proof sketch; streamlined `lem:GrpObj_mulRight_globalises` Step 1 to one-paragraph pointer; rewrote 3 iter-134 NOTE blocks as iter-135 honest-scaffold resolution NOTEs; de-pinned 3 stale line citations. |
| 2 (sequential) | `blueprint-writer` | mayervietoris-iter135 | **COMPLETE** (net 0 LOC) | 3 broken refs fixed at lines 769 (rephrased to drop non-existent `\ref{sec:basic_open_*}`) and 917 (`def:` → `thm:` prefix). All `\ref`s now resolve in-chapter. |
| 2 (sequential) | `blueprint-writer` | jacobian-iter135 | **COMPLETE** | New `\subsection{The positive-genus arm of the witness existence}` + `\lean{AlgebraicGeometry.positiveGenusWitness}` block + proof sketch; updated item (γ) prose + `thm:nonempty_jacobianWitness` proof iter-135 body-restructure paragraph; de-pinned `genusZeroWitness` line citation. |

## Plan-agent direct edits this iter (3 small edits)

1. `STRATEGY.md`: `Ideal.IsLocalRing.CotangentSpace` →
   `IsLocalRing.CotangentSpace` (`replace_all`, both occurrences).
   Per `strategy-critic-iter135` § "Prerequisite verification" naming
   wart (the actual Mathlib name is `IsLocalRing.CotangentSpace` in
   the `IsLocalRing` namespace at
   `Mathlib/RingTheory/Ideal/Cotangent.lean:299`; the `Ideal.` prefix
   mixed the file-path with the namespace).

2. `blueprint/src/content.tex`: added
   `\input{chapters/AlgebraicJacobian_Cotangent_GrpObj}` after the
   `RigidityKbar` line. Per blueprint-reviewer-iter135 bonus finding
   (the orphan chapter was previously not `\input`ed, so it never
   appeared in the rendered PDF/web blueprint).

3. `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`:
   - Restructured the `shearMulRight` bullet to record companion
     `@[simps]` lemmas + iter-134 closed status.
   - Added `schemeHomRingCompatibility` bullet to the per-Lean-file
     listing (resolves iter-134 lean-vs-blueprint-checker minor flag
     about the helper missing from the auxiliary chapter). Added a
     note clarifying it is NOT the φ for `PresheafOfModules.pullback`
     (consistent with the iter-135 analogist + Lean docstring addendum).

## STRATEGY.md edits this iter

Only 1: the naming-wart `replace_all` (item 1 above). The strategic
content is unchanged — the iter-135 strategy-critic returned SOUND on
the active critical path, and the 1 CHALLENGE was absorbed by the
mathlib-analogist + Wave-2 refactor rather than by an additional
STRATEGY.md edit.

The strategy-critic's 2 minor alternatives:

- **Alt 1** (land genus-stratified body restructure now): ADOPTED into
  the Wave-2 refactor (Change 2.1). Net effective M2-closure date
  potentially earlier — the iter-135-landed restructure means M2
  closure (formerly iter-157+ "restructure + close") is now reducible
  to "close both witness bodies" (the `genusZeroWitness` body iter-153–156
  + `positiveGenusWitness` body = M3 body, OFF-CRITICAL-PATH). The
  PROGRESS.md "Iter-135 changes landed this plan phase" section
  records this.

- **Alt 2** (temporary-axiom pile-composition smoke test ~iter-143):
  REJECTED-WITH-REBUTTAL — see § "Rebuttal to strategy-critic Alt 2"
  below.

## Rebuttal to strategy-critic Alt 2 (temporary-axiom pile-composition smoke test)

The strategy-critic-iter135 proposes that the iter-143 plan agent
dispatch an intermediate prover lane that attempts the M2.a body
closure with piece (iii) **axiomatised** (project-local axiom matching
the eventual piece (iii) signature, *removed* once piece (iii) lands),
to smoke-test pieces (i.b)+(i.c)+(ii) composition into the rigidity
body 8 iter earlier than the M2.a body closure lane.

**Rebuttal (explicit per plan.md § "Detecting and responding to stuck
routes" requirement that strategy-critic verdicts must be acted on or
explicitly rebutted)**:

1. **The iter-121 user directive bans new axioms.** The strategy-critic
   notes the rule may be read too strictly, arguing that a temporary
   smoke-test axiom that is introduced and removed in the same iter
   does not close M2.a. But the iter-121 user directive does not have a
   "same-iter removal" carve-out — its operative language is
   "**no named axioms**" as the end-state, with the project's autonomous
   loop "operating as a Mathlib contributor". An axiom that exists in
   the tree at *any* point in the loop's history is auditable; a
   reviewer asked "did this project ever introduce an axiom" would
   answer yes, even after removal. The cost is in user trust, not just
   in kernel cleanliness.

2. **The iter-135 type-elaboration check already serves as a
   lighter-weight integration spike.** The strategy-critic's CHALLENGE 1
   (1-iter type-check spike for piece (i.b)) is fully satisfied by the
   iter-135 mathlib-analogist's `lean_run_code` verification + the
   Wave-2 refactor's actual landing of the intended-type signatures.
   The same pattern can be applied for pieces (i.c) and (ii) when they
   come into scope (a mathlib-analogist dispatch + an honest sorry-
   bodied scaffold landing). That gives the same "do the pieces
   compose at the type level" signal as the temporary-axiom smoke
   test, without introducing any axiom.

3. **The strategy-critic's argument is real but the cost asymmetry
   tilts the wrong way.** A failure detected at iter-143 (via temporary
   axiom) vs. iter-151 (via real piece (iii)) saves 8 iter of build,
   per the strategy-critic. But: the iter-143 plan agent would have to
   stage the temporary-axiom infrastructure + commit it + remove it
   + audit the removal — each step a new failure surface. The
   iter-135 plan agent's judgment is that the lighter-weight
   type-elaboration check (analogist + sorry-bodied scaffolds, no
   axioms) gives 80% of the integration signal for 20% of the
   process cost. The full-strength integration signal (the actual
   composition compiles) is only available at the real iter-151+
   close anyway.

4. **The CONVERGING verdict on Route 1 + the 1-CHALLENGE SOUND verdict
   on the rest of the strategy reinforces this.** The iter-135
   progress-critic + strategy-critic are aligned that the strategy is
   healthy; iter-143 is far enough out that a deeper-think trigger
   then can reconsider, but the iter-135 pre-commitment is not to
   schedule a temporary-axiom lane.

**Iter-136 strategy-critic should NOT re-issue Alt 2.** If iter-136's
strategy-critic does re-issue it, the iter-136 plan agent should ratify
this iter-135 rebuttal in the iter-136 sidecar rather than re-litigate
in the absence of new evidence.

## META-PATTERN TRIPWIRE status

The iter-132 META-PATTERN TRIPWIRE non-promise commitment (no 4th body
reshape on `cotangentSpaceAtIdentity` under any future iter) **HOLDS**
this iter. The Wave-2 refactor did not touch `cotangentSpaceAtIdentity`,
`cotangentSpaceAtIdentity_eq_extendScalars`, or
`cotangentSpaceAtIdentity_finrank_eq` (piece (i.a) declarations DONE
iter-132). The refactor's edits to `Cotangent/GrpObj.lean` are confined
to the iter-134 placeholder section (lines ~421–574 of the iter-134
file state, now ~421–573 post-iter-135).

## Verification (refactor-side, plan-agent independent)

After the refactor returned, the plan agent independently ran:

- `mcp__archon-lean-lsp__lean_diagnostic_messages` on
  `Cotangent/GrpObj.lean` → 3 expected `declaration uses sorry` warnings
  on lines 468, 496, 560 (the 3 new honest scaffolds). No errors.
- `mcp__archon-lean-lsp__lean_diagnostic_messages` on `Jacobian.lean` →
  2 expected `declaration uses sorry` warnings on lines 193, 219
  (`genusZeroWitness`, `positiveGenusWitness`). The prior inline-sorry
  on `nonempty_jacobianWitness:236` is GONE. Plus 1 pre-existing
  long-line linter warning on line 275 (unchanged; protected signature).
- `mcp__archon-lean-lsp__lean_verify` on
  `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` →
  `{propext, sorryAx, Classical.choice, Quot.sound}` (kernel + sorry,
  no new axioms).
- `mcp__archon-lean-lsp__lean_verify` on
  `AlgebraicGeometry.nonempty_jacobianWitness` → same axiom set
  (sorry transmitted through the two scaffold bodies).

The refactor's self-report matches the independent verification.

## Sorry-count delta

Entering iter-135: **4** project sorries.
At iter-135 close: **6** project sorries. Net +2.

Per-file:

| File | Entering | At close | Delta |
|---|---|---|---|
| `Cotangent/GrpObj.lean` | 0 | 3 | +3 (3 NEW honest scaffolds REPLACING 3 prior weakened-wrong placeholders that `sorry_analyzer` could not see) |
| `Jacobian.lean` | 3 | 2 | −1 (inline `sorry` on `nonempty_jacobianWitness` REPLACED by `by_cases` delegation; the 2 scaffolds `genusZeroWitness` + `positiveGenusWitness` unchanged) |
| `RigidityKbar.lean` | 1 | 1 | 0 (unchanged) |

**Net semantic-health delta: materially positive.** The 4 → 6 count
increase reflects 3 placeholder-pattern declarations becoming
machine-readable as incomplete (which they always were) + 1
inline-`sorry` site converting to structural decomposition over named
scaffolds. The `sorry_analyzer` and `lean_verify` outputs are now
honest signals; before iter-135, they undercounted the actual work
remaining on piece (i.b).

## Health summary

- **Compiles**: yes (8330 jobs succeed; `lean_diagnostic_messages`
  returns exactly the expected warnings).
- **Axioms**: no new axioms. All refactor-touched declarations verify
  to kernel + sorry only.
- **Protected signatures**: untouched. `archon-protected.yaml`
  unchanged (9 declarations).
- **Blueprint consistency**: improved (5 chapters partial → all
  iter-135 writer-touched chapters complete; 1 bonus orphan resolved;
  cross-references now resolve in-chapter for the iter-135-touched
  chapters).
- **Mandatory critics**: 3/3 dispatched + returned + absorbed.
- **Iter-135 progress-critic PASS criterion** (≥ 2 of 3 placeholders
  to non-`Nonempty (X ≅ X)` types): **3/3, fully satisfied**.
- **META-PATTERN TRIPWIRE non-promise**: HELD (no `cotangentSpaceAtIdentity`
  body reshape this iter).
- **Trigger (a')**: NOT FIRED (sheaf-level RHS commitment held; the
  iter-135 honest scaffolds are typed against the sheaf-level RHS).
- **Trigger (a')/(c) LOC arm**: NOT FIRED (iter-135 added 0 LOC to
  (i.b)-side build — the refactor was a signature change, not new
  pile build).

## Fallback if no user response

This iter has no user-escalation pending and no plan-agent escalation
of a `STUCK`/`CHURNING` route. `USER_HINTS.md` is empty and stays empty.
The iter-136 plan agent does NOT need a user-silent-fallback section.

If iter-136's mandatory critics turn up a surprise (CHURNING / STUCK on
Route 4, blueprint-reviewer HARD GATE DEFER on `RigidityKbar.tex` even
after iter-135 writer pass, etc.), the iter-136 plan agent should
dispatch the appropriate corrective per the standard protocol. The
iter-135 close state does not pre-commit iter-136 to a specific
prover lane shape beyond the watch criteria in PROGRESS.md.

## Pointer to PROGRESS.md

PROGRESS.md (rewritten this iter) carries the full iter-135-close
state: end-state overview, per-piece status, sorry inventory, iter-135
changes landed list, verification table, and watch criteria for
iter-136. The narrative "what changed and why" lives here in this
sidecar; PROGRESS.md is the consumable state.
