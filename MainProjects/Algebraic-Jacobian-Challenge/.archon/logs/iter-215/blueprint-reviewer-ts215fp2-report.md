# Blueprint Review Report

## Slug
ts215fp2

## Iteration
215

## Scope
Scoped re-review of `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` only,
per the HARD GATE fast-path protocol. Audit question: is the `tensorobj_restrict_iso`
critical-path self-contradiction fully resolved?

---

## Gate Verdict: NOT-CLEARED

The Step 3 fix in `lem:tensorobj_restrict_iso`'s proof is confirmed correct — Step 3
is now titled "(the genuine residual)" and states that `tensorobj_restrict_iso` IS on
the critical path under the PRIMARY locally-trivial route. However, **two other
sentences in the chapter were not updated** and still directly contradict that fix.
Both are general (non-route-(e)-fallback, non-flat-whisker) claims that remain live
contradictions while the PRIMARY route depends on `tensorobj_restrict_iso`.

---

## Residual must-fix (2 items)

### Must-fix 1 — `sec:tensorobj_onproduct_lift` intro, line 437–438

**Offending text** (lines 434–438):
> The open-immersion restriction-compatibility isomorphism
> `\cref{lem:tensorobj_restrict_iso}` is retained as an **off-path supplement, not as a
> group-law ingredient**; cf. `\cref{rem:scheme_modules_monoidal_off_path}`.

**Contradiction**: Step 3 of `lem:tensorobj_restrict_iso`'s own proof (the newly fixed
text) says *"Closing Step 3 is therefore a primary obligation, not an optional
supplement."* The PRIMARY route proof of `lem:islocallyinjective_whisker_of_W` carries
`\uses{..., lem:tensorobj_restrict_iso, ...}` and explicitly says the lemma "moves
**onto** the critical path." This sentence in the section intro (which is NOT
route-(e)-fallback prose — it is the general section overview) still calls it "an
off-path supplement, not as a group-law ingredient."

**Fix required**: Remove or qualify this sentence. It should acknowledge that under
the PRIMARY locally-trivial route `tensorobj_restrict_iso` is on the critical path (as
Step 3 now correctly states), and is only an off-path supplement under the route-(e)
stalkwise fallback.

---

### Must-fix 2 — `sec:tensorobj_consistency_check`, lines 1795–1801

**Offending text**:
> `\item The off-critical-path supplements`
> `\cref{lem:restrictscalars_laxmonoidal,lem:tensorobj_restrict_iso,%`
> `      lem:tensorobj_preserves_locally_trivial,%`
> `      lem:tensorobj_inverse_invertible}` use
> `\cref{def:scheme_modules_tensorobj}`; **none of them is consumed by the group law**,
> which rests on `\cref{lem:tensorobj_isoclass_commgroup}` and
> `\cref{def:scheme_modules_isinvertible}`.

**Contradiction**: The internal consistency check labels `lem:tensorobj_restrict_iso`
an "off-critical-path supplement" consumed by nobody. But:

1. `lem:islocallyinjective_whisker_of_W`'s proof block carries
   `\uses{..., lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso}` and its PRIMARY
   route explicitly depends on it.
2. The transitive `\uses` chain is:
   `lem:tensorobj_isoclass_commgroup` → `lem:tensorobj_assoc_iso` →
   `lem:jw_ismonoidal` → `lem:whisker_of_W` →
   `lem:islocallyinjective_whisker_of_W` (proof, PRIMARY route) →
   **`lem:tensorobj_restrict_iso`**.
   So `lem:tensorobj_restrict_iso` IS transitively consumed by the group law.
3. The same bullet also lists `lem:tensorobj_inverse_invertible` as "off-critical-path"
   and "not consumed by the group law," but `lem:tensorobj_isoclass_commgroup`'s
   `\uses` block directly includes `lem:tensorobj_inverse_invertible`. This is a
   secondary error in the same bullet.

The consistency check section was not updated when Step 3 was fixed. It still reflects
the OLD picture where `tensorobj_restrict_iso` was off the critical path.

**Fix required**: Move `lem:tensorobj_restrict_iso` out of the "off-critical-path
supplements" bullet. Add a bullet (or extend the `lem:islocallyinjective_whisker_of_W`
bullet) noting that its PRIMARY route proof depends on `lem:tensorobj_restrict_iso` and
thereby places it on the critical path. Also correct the `lem:tensorobj_inverse_invertible`
error (it is directly in the `\uses` of `lem:tensorobj_isoclass_commgroup`).

---

## Additional observation (not a new must-fix, but coherence note)

`sec:tensorobj_motivation` paragraph at lines 122–134 ("`With J.W.IsMonoidal in hand…`")
ends with "The geometric compatibility isomorphism `tensorObj_restrict_iso` (…) and any
separate tensor-inverse lemma are *off* this critical path." Taken narrowly, "this
critical path" reads as the path from J.W.IsMonoidal→LocalizedMonoidal→group law, where
`tensorobj_restrict_iso` is genuinely not needed (the associator etc. come from the API
for free). This is arguably legitimate route-(e) fallback prose and does NOT contradict
the PRIMARY route — which concerns the path to *getting* J.W.IsMonoidal. However, once
the two must-fixes above are applied, the plan agent should verify this paragraph is not
re-read as a general chapter claim; a one-clause qualifier like "under route-(e), once
J.W.IsMonoidal is in hand" would remove any residual ambiguity.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `sec:tensorobj_onproduct_lift` intro (line 437–438): labels `tensorobj_restrict_iso`
    "an off-path supplement, not as a group-law ingredient" — contradicts the Step 3 fix
    (PRIMARY route depends on it). **Must-fix 1.**
  - `sec:tensorobj_consistency_check` (lines 1795–1801): lists `lem:tensorobj_restrict_iso`
    under "off-critical-path supplements" and says "none of them is consumed by the group
    law" — contradicts Step 3 fix and the transitive `\uses` chain. **Must-fix 2.**
  - Secondary error in the same consistency-check bullet: `lem:tensorobj_inverse_invertible`
    is called "off-critical-path" and "not consumed by the group law," but the `\uses`
    block of `lem:tensorobj_isoclass_commgroup` explicitly includes it (minor, fold into
    must-fix 2 repair).
  - Step 3 of `lem:tensorobj_restrict_iso`'s proof: CORRECT post-fix. Title "(the genuine
    residual)" and closing prose ("Closing Step 3 is therefore a primary obligation, not
    an optional supplement") are consistent with the PRIMARY route.
  - PRIMARY route proof of `lem:islocallyinjective_whisker_of_W`: CORRECT. Detailed,
    uses `lem:tensorobj_restrict_iso` + unit unitor, no stalks, no (d.2). Proof sketch
    adequate for a prover.
  - `lem:tensorobj_isoclass_commgroup` PRIMARY construction: CORRECT in its own text.
    The "primary tier" description in `sec:tensorobj_route_e` is consistent with the
    two-tier picture.

## Severity summary

- **must-fix-this-iter**: 2 (Must-fix 1 and Must-fix 2 above — both are unqualified
  "off-path" claims for `lem:tensorobj_restrict_iso` outside route-(e) fallback prose,
  directly contradicting the PRIMARY route proof and the Step 3 fix).
- **soon**: 0
- **informational**: 1 (the motivation paragraph at lines 122–134; coherence note above)

Overall verdict: NOT-CLEARED. The Step 3 fix is correct, but two sentences outside the
proof — `sec:tensorobj_onproduct_lift` intro (line 437–438) and `sec:tensorobj_consistency_check`
(lines 1795–1801) — still label `lem:tensorobj_restrict_iso` as off the critical path
without qualification, directly contradicting the PRIMARY route proof. Both must be
repaired before the gate clears.
