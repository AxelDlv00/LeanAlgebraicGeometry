# blueprint-reviewer — iter184

## Iter

184 (planner is composing iter-184 prover lane set; iter-183 has just closed).

## Why this dispatch

Mandatory plan-phase dispatch (the descriptor lists this as
HIGHLY RECOMMENDED). Specific gates for this iter:

1. **NEW chapter `Albanese_CoheightBridge.tex`** (landed iter-183
   plan-phase via blueprint-writer `coheightbridge-skeleton`,
   ~477 lines) is being relied on by the iter-184 Lane M downstream
   (`Albanese/CodimOneExtension.lean`). First whole-blueprint audit
   that sees it — confirm completeness + correctness as a HARD GATE
   pre-req for that lane.

2. **NEW chapter `RiemannRoch_OcOfD.tex`** (landed iter-182 plan-phase
   then audited iter-183; HARD GATE cleared then). iter-184 Lane K
   plans to attempt body work; re-verify the chapter is still
   complete+correct.

3. **iter-183 chapter touches that I'm not aware of** — the planner
   has NOT edited any chapter this plan-phase. But review whatever
   was sync_leanok-touched as part of your usual whole-blueprint
   audit.

4. **iter-183 blueprint-reviewer findings to re-verify in this audit**:
   - **must-fix-this-iter**: A.3 unstarted phase. Chapter
     `Picard_IdentityComponent.tex` is being added this iter-184
     plan-phase via `blueprint-writer pic0-identity-component-chapter`.
     Re-audit the new chapter after it lands (the dispatch order
     means the chapter may be on disk by the time you read this).
     If the new chapter is present, audit it for completeness +
     correctness as a new chapter; if absent, just note "deferred —
     dispatched but not landed in time for this audit".
   - **soon-severity**: `Picard_RelativeSpec.tex` signature drift on
     `UniversalProperty` / `affine_base_iff` / `base_change`.
     Documented in-chapter as `% NOTE (iter-173 review)` blocks.
     iter-184 Lane D is closing `pullback_iso_construction` body but
     NOT touching the 3 drift sigs (those are iter-185+ work).
     Confirm the drift notes still match the Lean signatures.
   - **informational**: Grassmannian sub-chapter promotion candidate
     (not gating). Pass-through; no action required.

5. **Broken `\uses{}` cross-refs in `RiemannRoch_RRFormula.tex`** (per
   iter-183 blueprint-doctor): `\uses{\leanok thm:divisor_degree_hom}`
   and `\uses{\leanok thm:euler_char_eq_deg_plus_one_minus_genus}` —
   the `\leanok` token is incorrectly inside the `\uses{}` argument.
   A blueprint-writer dispatch `rrformula-uses-fix` is being fired
   this plan-phase to fix it. Re-verify the fix landed correctly
   when you audit `RiemannRoch_RRFormula.tex`.

## Files for the iter-184 prover lane HARD GATE

For each lane that's still PARTIAL or PROPOSED for iter-184, the
corresponding chapter must be `complete: true correct: true` with
no must-fix-this-iter findings. The 10 iter-184 active lane files:

1. `Genus0BaseObjects/GmScaling.lean` — chapter: ``chapters/AbelianVarietyRigidity.tex`` (consolidated, `% archon:covers` block).
2. `AbelianVarietyRigidity.lean` — chapter: ``chapters/AbelianVarietyRigidity.tex`` (consolidated).
3. `Albanese/AuslanderBuchsbaum.lean` — chapter: ``chapters/Albanese_AuslanderBuchsbaum.tex``.
4. `Albanese/CodimOneExtension.lean` — chapter: ``chapters/Albanese_CodimOneExtension.tex``.
5. `Picard/RelativeSpec.lean` — chapter: ``chapters/Picard_RelativeSpec.tex``.
6. `Picard/QuotScheme.lean` — chapter: ``chapters/Picard_QuotScheme.tex``.
7. `RiemannRoch/OCofP.lean` — chapter: ``chapters/RiemannRoch_OCofP.tex``.
8. `RiemannRoch/OcOfD.lean` — chapter: ``chapters/RiemannRoch_OcOfD.tex``.
9. `RiemannRoch/RRFormula.lean` — chapter: ``chapters/RiemannRoch_RRFormula.tex``.
10. `RiemannRoch/RationalCurveIso.lean` — chapter: ``chapters/RiemannRoch_RationalCurveIso.tex``.

## What you check

Standard whole-blueprint review per descriptor:
- Per-chapter status (`complete: true|partial|false`,
  `correct: true|false`).
- Unstarted-phase proposals across the strategy.
- Cross-chapter consistency / broken refs.
- HARD GATE verdict per `.lean` file for the iter-184 set.

## Output

Standard checklist + must-fix-this-iter / soon-severity / informational
buckets + the unstarted-phase proposals section.

## Note for the audit

The planner has dispatched a `blueprint-writer pic0-identity-component-chapter`
in parallel with this audit. If the new chapter lands during your
read, audit it as a new chapter; if not, note "deferred". Either way
do not flag its absence as a NEW must-fix-this-iter (it is being
addressed this plan-phase).
