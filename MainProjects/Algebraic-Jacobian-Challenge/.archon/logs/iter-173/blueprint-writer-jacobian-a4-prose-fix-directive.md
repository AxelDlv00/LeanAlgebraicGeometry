# Blueprint-writer directive — slug `jacobian-a4-prose-fix`

## Target chapter

`blueprint/src/chapters/Jacobian.tex`.

## Why

iter-172 lean-vs-blueprint-checker `jacobian172` flagged as a **MAJOR** finding: the chapter is **internally inconsistent** on the Route A.4 cost estimate.

- The iter-172 `blueprint-writer a4-bypass-audit` returned verdict **outcome (b) — bypass FAILS** (Milne III §6 Prop 6.1 invokes Thm 3.2 directly; the autoduality-via-cube detour was excised iter-163). The verdict landed in the chapter at L574–L602 (the `% NOTE` block under `sec:Jacobian_routeA4_albaneseUP`) and L641–L657 (inside the proof of `thm:albanese_universal_property`).
- However, **three earlier paragraphs still carry the pre-audit bypass-holds prose**:
  - L344 (`\emph{Mathlib status for Route A}` itemisation): A.4 "$\sim 900$–$1200$ LOC, $\sim 7$–$11$ iters" with no Thm 3.2 / Lemma 3.3 caveat.
  - L384–L390 (`(A.4)` Albanese universal property bullet): "Net new project material: $\sim 900$–$1200$ LOC. Iters: $\sim 7$–$11$. Milne Proposition~6.1 / 6.4. ... Char-free." — directly states the bypass.
  - L425–L427 (Mathlib-prerequisite cascade for Route A): "(A.4) $\to$ no new Mathlib namespace; reuses `AlgebraicJacobian.AbelianVarietyRigidity` (in tree, axiom-clean) + Mathlib's Albanese-style universal property machinery."

A planner reading the chapter top-to-bottom sees the optimistic estimate first and only encounters the contradiction inside the proof. This is exactly the failure pattern the audit was supposed to repair.

## Output requirements

- Edited `Jacobian.tex` (write_domain).
- Reconcile the three flagged paragraphs (L344, L384–L390, L425–L427) with the iter-172 audit verdict at L574–L602 + L656. Each updated paragraph must:
  - Explicitly state outcome (b): "Bypass via Milne autoduality FAILS; A.4 inherits the Thm 3.2 + Lemma 3.3 + Auslander–Buchsbaum sub-build."
  - Cite the audit location: "(See iter-172 audit at \S`sec:Jacobian_routeA4_albaneseUP`, NOTE block + `thm:albanese_universal_property` proof.)"
  - Update the iter / LOC estimate to "$\sim 22$–$35$ iters, $\sim 2500+$ LOC" (matching the STRATEGY.md A.4 row update).
  - Update the prerequisite cascade to include: "Thm 3.2 (`lem:rational_map_to_av_extends`) + Lemma 3.3 codim-1 extension + Weil-divisor API (some shared with RR.1) + Auslander–Buchsbaum (absent in Mathlib)."
- **Minor (free pickup)**: fix the stale line-number reference at L556 (`AlgebraicJacobian/Jacobian.lean:120--126`) to L134--L140 — `geometricallyIrreducible_id_Spec` was moved.

## Constraints

- Do **NOT** change the `\lean{...}` pins, theorem statements, or proof structure of the chapter — only the three flagged prose paragraphs (and the L556 line-number).
- Stay within the chapter; do not change `Jacobian.tex`'s `% archon:covers` line (this chapter is the single-file blueprint for `Jacobian.lean`).
- **NEVER** add `\leanok` or `\mathlibok` markers.
- After the fix, the chapter must be **internally self-consistent**: a planner reading top-to-bottom sees one A.4 estimate ($\sim 22$–$35$ iters), and the same estimate is repeated wherever A.4 is discussed.

## Verification step

After writing, grep the chapter for:
- "$\sim 7$–$11$" or "7--11" or "900--1200" — these should NOT appear in any A.4 / Albanese context.
- "bypass holds" / "no new Mathlib namespace" in A.4 context — these should NOT appear.
- "$\sim 22$–$35$" or "Thm 3.2" or "Lemma 3.3" — these SHOULD appear in every A.4 cost paragraph.

Internal consistency is the load-bearing requirement.
