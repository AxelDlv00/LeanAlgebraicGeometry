# Blueprint Review — iter-194 fast-path

**Scope**: Re-audit of 2 chapters only (iter-194 same-iter fast-path).
**Auditor**: blueprint-reviewer subagent, iter-194.

---

## Per-chapter verdict blocks

```yaml
- chapter: RiemannRoch_H1Vanishing
  complete: true
  correct: true
  must-fix-this-iter: []
  notes: >
    Both WD-1 corrective items are fully addressed. The two new `\lemma` blocks
    exist: `lem:flasque_cokernel_short_exact` (lines 184–223) with
    `\lean{AlgebraicGeometry.Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque}`
    and `lem:ext_succ_zero_of_injective_lower_zero` (lines 225–258) with
    `\lean{AlgebraicGeometry.ext_succ_eq_zero_of_injective_of_lower_zero}`. Both
    pins are verified against `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`:
    `Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque` (line 356,
    axiom-clean) and `ext_succ_eq_zero_of_injective_of_lower_zero` (line 273,
    axiom-clean) exist as public theorems inside `namespace AlgebraicGeometry`.
    No stale "ancillary lemmas not given their own pin" disclaimer is present in
    the file. The `\section{Out of scope}` (lines 620–646) contains only
    legitimate out-of-scope notes (Serre duality, Grothendieck vanishing, H⁰
    half), not the retired disclaimer.

- chapter: Albanese_CodimOneExtension
  complete: true
  correct: partial
  must-fix-this-iter:
    - >
      M-2 quality issue (non-blocking for HARD GATE, blocking for future \leanok):
      The \lean{...} pins on `lem:module_free_kaehler_localization` and
      `lem:rank_kaehler_localization_eq_relative_dim` reference
      `AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization` and
      `AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension`.
      These declarations exist in `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
      (lines 325 and 351 respectively) but are declared as `private theorem`. Private
      declarations are not accessible by their fully-qualified public names from
      outside the file, so the blueprint tooling cannot machine-verify these pins.
      No \leanok is claimed (the lemma blocks intentionally lack \leanok), so this
      does not falsely assert kernel-clean status. However, \leanok cannot be added
      to these blocks until the declarations are promoted from `private` to public.
      Fix before adding \leanok: remove `private` from both helpers in
      CodimOneExtension.lean (or, if they must stay private, prefix the \lean{...}
      pins with a note that they are internal-only and cannot be \leanok-verified).
  notes: >
    All three WD-2 corrective items are present. M-1: a `% NOTE (iter-194 reviewer)`
    block (lines 297–309) inside `lem:smooth_to_regular_local_ring` documents the
    Stacks 00TT gap: the Lean body of `isRegularLocalRing_stalk_of_smooth` is a
    typed sorry gated on Stacks 00OE + 02JK Mathlib gaps, Stages 5a/5b are
    axiom-clean (iter-193), Stage 6 tracked iter-200+. M-2: two new `\lemma` blocks
    exist — `lem:module_free_kaehler_localization` (lines 209–233) with
    `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}`
    and `lem:rank_kaehler_localization_eq_relative_dim` (lines 235–264) with
    `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}`.
    The named declarations do exist in CodimOneExtension.lean (lines 325, 351) and
    are axiom-clean, but are marked `private`; see must-fix note above. M-3: the
    `thm:weil_divisor_obstruction` block retains no `\lean{...}` pin; a `% NOTE
    (iter-194 writer)` block (lines 762–773) documents the gap (no corresponding
    Lean declaration, Stacks RationalMap-to-function-field pullback machinery absent
    from Mathlib at b80f227, with the weaker reshuffle pinned at
    `lem:mem_domain_partial_map_reshuffle` as the honest fallback). The documented-gap
    option is satisfied.
```

---

## HARD GATE verdicts

- **H1Vanishing** HARD GATE: ✅ PASS
- **CodimOneExtension** HARD GATE: ✅ PASS

---

## Summary of residual issues

| Item | Chapter | Severity | Blocking? |
|------|---------|----------|-----------|
| M-2: `\lean{...}` pins reference `private` declarations | CodimOneExtension | Quality | Not blocking for prover dispatch; blocks future `\leanok` addition |

Both HARD GATE failures from the iter-194 whole-blueprint review (Lane H and Lane M↓)
are cleared. Lane H and Lane M↓ may proceed to iter-194 prover dispatch via the
same-iter fast path.

The M-2 residual (private declarations) does not block prover dispatch — the provers
can work with the private helpers internally — but must be resolved before `\leanok`
can be added to `lem:module_free_kaehler_localization` and
`lem:rank_kaehler_localization_eq_relative_dim`. The fix is one line per declaration:
change `private theorem` to `theorem` in `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
at lines 325 and 351.
