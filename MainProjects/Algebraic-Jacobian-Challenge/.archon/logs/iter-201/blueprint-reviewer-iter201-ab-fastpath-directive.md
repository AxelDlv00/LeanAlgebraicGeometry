# blueprint-reviewer directive — slug `iter201-ab-fastpath`

## Scope (narrow)

Re-review **only** `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
post the iter-201 plan-agent same-iter fast-path fix of the 3
`Lemma~REF` cross-reference placeholders flagged by your prior
`iter201` dispatch as must-fix-this-iter.

The fixes landed:
1. **L251** (`lem:depth_short_exact_sequence` proof body):
   `Lemma~REF` → `\cref{lem:depth_via_ext}`.
2. **L376** (`thm:auslander_buchsbaum` proof body, base case):
   `Lemma~REF` → `\cref{lem:depth_short_exact_sequence}`.
3. **L391** (`thm:auslander_buchsbaum` proof body, inductive step):
   `Lemma~REF` → `\cref{lem:depth_short_exact_sequence}`.

Additionally, the `soon`-rated finding was also fixed for cleanliness:
4. **L1064** (`cor:regular_cohen_macaulay` proof remark):
   `Theorem~REF` → `\cref{thm:auslander_buchsbaum}`.

No other content was changed; the fixes are mechanical substitutions.

## What you check

1. Confirm the 3 must-fix `Lemma~REF` substitutions resolved.
2. Confirm no other must-fix or major regression introduced.
3. Re-render the HARD GATE verdict for Lane AB-Stacks-00MF (was
   CONDITIONAL `complete:true, correct:partial`; expected CLEARS
   `complete:true, correct:true`).

You may NOT re-read the rest of the blueprint; this is a narrow
scoped re-review. Other chapters retain their prior `iter201`
verdicts.

## Output format

Per descriptor: per-chapter checklist for `Albanese_AuslanderBuchsbaum.tex`
only + must-fix findings + HARD GATE verdict re-render. Concise.
