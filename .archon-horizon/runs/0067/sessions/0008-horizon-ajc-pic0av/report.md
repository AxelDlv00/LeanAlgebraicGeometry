Both threads acknowledged and answered. Nothing left uncommitted; the workspace is hand-off clean.

## Summary

Three of the A.3 leg's residues were replaced by statements the pinned mathlib can express — none by the route its own docstring predicted. A fresh-context review then overturned the strength claim on the headline one, and the correction produced a better theorem than the original claim would have.

Mathematically: smoothness of Pic⁰ now needs `IsReduced` of the **single** scheme `Pic⁰ ×_k Spec k̄`, and that same hypothesis discharges the file's separate `geometricallyReduced` sorry. Properness needs only the **valuative lifting** condition, retiring the standing caveat that Kleiman's quasi-projectivity vocabulary is absent from mathlib. Sorry counts unchanged (3/3/1) — what changed is what they must prove.

## Progress

- `Picard/GroupSchemeSmoothAlgClosed.lean`: NEW, 2 declarations, sorry-free, axiom-clean, rooted. Re-derives mathlib's `private smooth_of_grpObj_of_isAlgClosed` — both projects had priced "get it made public" as an upstream PR, but `private` hides the name, not the proof, and that proof uses only public API. Transcribed verbatim, zero errors first try.
- `Picard/Pic0AbelianVariety.lean`: 3 sorries → 3, four new sorry-free declarations — `smooth_of_isReduced_algebraicClosureBaseChange`, `geometricallyReduced_of_isReduced_algebraicClosureBaseChange` (the review's corollary: one hypothesis, two obligations), `universallyClosed_of_valuativeCriterion`, `proper_of_valuativeCriterion`. The `quasiCompact` lemma previously filed as "not needed for the proper assembly" is exactly what the valuative route consumes.
- `Picard/IdentityComponent.lean`: 3 → 3, four new sorry-free declarations. `ClassDegreePinned` pins the degree against the **Abel map** rather than `WeilDivisor.degree`, which needs a relative comparison AJC lacks. The zero-map refutation is a theorem in the tree, with its limit stated: conditional on a `DivFamily` producer AJC does not have.
- `AlgebraicJacobian.lean`: rooted the new module; root build 8770 → 8773 jobs, exit 0.
- Deleted one file of my own — it duplicated a lemma ajc-rr landed 20 minutes earlier under the same name.

## Issues

- **The review found my headline claim wrong.** I said the smoothness criterion is *strictly weaker* than mathlib's; AJC owns the converse (`Smooth.geometricallyReduced`), so the two are interprovable and it is a restatement. Cause: I measured "absent" inside the edited file's 99-module cone instead of the root's 215. Corrected at four sites; I-0567 amended; rule filed as I-0588. `ajc-fbc` hit this identically the same hour.
- **Front (d) is not closable, and I retired its obstruction too early.** ajc-rr's `degree_principal_eq_zero_curve` *is* my sorry's conclusion, but its file's 50-file cone contains `WeilDivisor.lean`, so it sits downstream of the leaf. I had checked the χ-ledger cone (importable) but not the cone of the file that proves my statement — the third cone-scoping error of the day, all now recorded together.
- **Two of three subagents returned no report** (survey ~80 min, janitor ~40 min); `work-reviewer` delivered and was the session's most valuable input. Filed as I-0599. The janitor not landing means **the required hygiene pass did not happen** — 72 open inbox items and two roadmap parent/child mismatches remain unaddressed by me. I am not claiming that pass occurred.
- Cleared 22 phantom staged deletions (hash-verified identical to HEAD first); ajc-albanese did the same concurrently. Verified ajc-rr's fix to the ledger collision I filed as I-0576 — it now co-roots and the transport is axiom-clean against the full root, but the ledger is still **not rooted**, so its 40 files remain unelaborated by the root target.
- Standing limit: all of this is axiom-clean **given** `[HasPicScheme C]`, whose only discharger is conditional. `Pic0.smooth`, `Pic0.proper`, `isAbelianVariety` still report `sorryAx`.

## Why I stopped

Partly advanced, not complete — no terminal status set, so the task returns to the queue. None of the four fronts closed. Front (a) did not move here; AJCR narrowed it to one geometric statement on their side. Fronts (b) and (c) now have formalisable residues where they had walls. Front (d) is blocked on one import edge with all the mathematics proved on the wrong side of it.

## Next

1. **Reducedness of `Pic⁰ ×_k Spec k̄`** is now the whole of both smoothness *and* `geometricallyReduced` — Cartier in characteristic zero, a genuine statement in characteristic p.
2. **The valuative existence half** for properness: through representability, "an invertible sheaf on `C ×_k Spec K` extends over a valuation ring".
3. **Front (d) needs a boundary decision, not mathematics** — drop the sorried branch and let ajc-rr's theorem be the project's statement of it (my preference), or split the index bridge.
4. **Root the χ-ledger**: 40 files, verified co-rootable, imported by nothing.
5. A janitor pass is still owed.
