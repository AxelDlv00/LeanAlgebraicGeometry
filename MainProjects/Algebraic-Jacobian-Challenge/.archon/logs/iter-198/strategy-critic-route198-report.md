# Strategy Critic Report

## Slug
route198

## Iteration
198

## Routes audited

### Route: A.1.a — RelativeSpec

- **Goal-alignment**: PASS — substrate for relative-Spec is a real precondition of Pic representability.
- **Mathematical soundness**: PASS — Stacks 27.* (01LM/01LP/01LT) is the canonical construction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — listed as 0 iters / landed.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND.
  *Caveat to verify:* `grep -c sorry AlgebraicJacobian/Picard/RelativeSpec.lean` returns 7. Likely string matches inside comments / docstrings (the strategy is consistent with `0` *inline* sorries), but the planner should reconcile to make the "0 sorries" claim auditable.

### Route: A.4.a — Weil-divisor / codim-1 substrate (Stacks 02RV)

- **Goal-alignment**: PASS — codim-1 finite-support theory feeds A.4.c.0 → A.4.c.1 → Albanese UP.
- **Mathematical soundness**: PASS — Stacks 02RV is the right anchor; height-1 prime decomposition + DVR-stalk valuation is standard.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none (height-1 primes, DVR valuations all exist in Mathlib as `Ring.DimensionLE`/`IsDiscreteValuationRing` machinery).
- **Effort honesty**: reasonable — 150–400 LOC at 0/it is a fair "not started" entry. The 3–6 iter band is tight given a multi-iter `n=k+1` cousin (A.4.b) gets 6–12 iters for similar Matsumura-grade work; expect to widen once started.
- **Parallelism under-exploited**: no — A.4.a, A.4.b, A.3.0 are flagged as independent and can dispatch concurrently.
- **Verdict**: SOUND.
  *Note:* The file `RiemannRoch/WeilDivisor.lean` carries 12 `sorry` matches and is shared with frozen RR.1 lemmas. The "A.4.a sorries in-scope, RR.1 sorries PAUSED" boundary must be enforced lane-by-lane to avoid accidental RR.1 churn — the strategy correctly names this but does not name the specific sorry locations the prover is allowed to touch beyond L249. Listing the A.4.a-owned line numbers in `task_pending.md` is a planner action item, not a STRATEGY.md issue.

### Route: A.4.b — Auslander–Buchsbaum (n=k+1)

- **Goal-alignment**: PASS — direct input to A.4.c.1 (Thm 3.2 assembly).
- **Mathematical soundness**: PASS — Matsumura §19 / Stacks 090V; canonical proof.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — `~200–300 · ~50/it` over 6–12 iters is internally consistent.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND.

### Route: A.1.c — RelPic functor

- **Goal-alignment**: PASS — relative Pic functor must exist before representability.
- **Mathematical soundness**: PASS — ét-sheafify + LineBundle.OnProduct are the right ingredients.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — it is gated on the carrier-soundness probe, not deferred.
- **Phantom prerequisites**: none (étale topology + sheafification both exist in Mathlib).
- **Effort honesty**: reasonable; 0/it velocity is honest for a not-yet-started gated phase.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND.

### Route: A.2.c — FGA Pic_{C/k} (Cartier path)

- **Goal-alignment**: PASS — representability of Pic_{C/k} is required.
- **Mathematical soundness**: **PARTIAL** — see Mathematical-soundness CHALLENGE below.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the bypass of A.2.a (flattening) + A.2.b (Quot) renames the gap rather than retiring it. See Infrastructure-deferral findings.
- **Phantom prerequisites**: "Cartier representability" — there is no standard FGA theorem of this name that represents `Pic_{C/k}` without Quot. The standard FGA Pic representability proof (Kleiman §4.8 and Murre §3 in FGA Explained Ch.9) uses the relative Quot scheme as an intermediate step. The "Cartier path" terminology appears unique to this strategy without a literature anchor.
- **Effort honesty**: under-counted if Quot machinery is actually needed; reasonable only conditional on the Cartier-only proof being real.
- **Parallelism under-exploited**: no.
- **Verdict**: **CHALLENGE**.

### Route: A.4.c.0 / A.4.c.1 — codim-≥2 + Thm 3.2 assembly

- **Goal-alignment**: PASS — gives "rational maps into AV extend over codim-≥2", which is the Albanese UP backbone.
- **Mathematical soundness**: PASS — Stacks 00OE + 02JK + Milne Thm 3.2 are canonical.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: A.3.0 / A.3.ii–vii — tangent + Pic⁰ AV-structure wrap

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PARTIAL — A.3.ii rests on `PicScheme.degComp` (Kleiman `thm:Pphifin`), which requires a Hilbert-polynomial open-and-closed decomposition. Mathlib has no scheme-level Hilbert polynomial. The strategy lists this as A.3.vii substrate at ~80–200 LOC; this is light for a from-scratch Hilbert-polynomial construction.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: borderline — the `pic0-ker-deg-pivot` analogy explicitly tags Pphifin as `NEEDS_MATHLIB_GAP_FILL`. The strategy carries it as an in-scope phase, so this is not silent deferral, but the LOC estimate looks wishful.
- **Phantom prerequisites**: scheme-level Hilbert polynomial (not in Mathlib b80f227) — to be built in-project.
- **Effort honesty**: under-counted for A.3.vii — Hilbert polynomial of coherent sheaves over a Noetherian base, plus the `Pphifin` decomposition, is more than 80–200 LOC of Mathlib-grade work.
- **Verdict**: CHALLENGE (effort estimate; not the route itself).

### Route: A.4.d.0 / A.4.d — Cartier-route Pic^d + divisor-map Albanese UP

- **Goal-alignment**: PASS — produces the Albanese UP for `Pic⁰_{C/k}`.
- **Mathematical soundness**: PASS — Cartier-divisor on `C × Pic^d` is a real construction (Poincaré bundle), once Pic^d exists.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND.

### Route: genusZero witness body + k̄→k descent (priority 6)

- **Goal-alignment**: PARTIAL — the route closes the genus-0 arm of `nonempty_jacobianWitness`, but the path is not spelled out.
- **Mathematical soundness**: PARTIAL — the natural argument ("dim Pic⁰_{C/k} = dim_k H¹(C, O_C) = 0 ⇒ Pic⁰ is étale and connected ⇒ Pic⁰ = Spec k") requires A.3.0 + A.3.iii (tangent iso) + A.3.vi (geom-irred). That is consistent with the dependency graph. The strategy does NOT, however, explain why this path closes without RR.4 / `genusZero_curve_iso_P1`, which are PAUSED. A fresh reader cannot tell whether the genus-0 witness is genuinely Route-C-independent. Make the proof sketch explicit (one paragraph in `## Routes`).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no, conditional on the Route-C-independence being real.
- **Phantom prerequisites**: "terminal cluster Spec k" — this is a colloquialism, not a Mathlib name. State the lemma being assumed (something like `0-dim connected reduced group scheme over a field is the terminal object`).
- **Effort honesty**: reasonable.
- **Verdict**: CHALLENGE — name the lemma chain explicitly.

### Route: Route C — PAUSED permanently

- **Goal-alignment**: **FAIL** — see Infrastructure-deferral findings.
- **Mathematical soundness**: n/a (paused).
- **Sunk-cost reasoning detected**: no, but the pause is dressed in process language ("USER 2026-05-28 standing directive") rather than mathematical justification.
- **Infrastructure-deferral detected**: **yes** — see Infrastructure-deferral findings.
- **Phantom prerequisites**: n/a.
- **Effort honesty**: n/a.
- **Verdict**: **REJECT** as a stable strategic posture; rework required.

### Route: Carrier-soundness probe (FGAPicRepresentability refactor)

- **Goal-alignment**: PASS — directly serves the kernel-only-axiom end-state contract.
- **Mathematical soundness**: PASS — the `Functor.IsRepresentable` / `Functor.reprX` idiom is verified-real Mathlib (confirmed via `lean_leansearch`).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND in approach, but the **abort criterion is too vague**: "If still showing silent `sorryAx`, revert" leaves "showing" undefined. State the exact `lean_verify` target declarations, the expected pass set (`[propext, Classical.choice, Quot.sound]`), and the rollback target SHA. CHALLENGE on the criterion's precision, not the probe itself.

## Format compliance

- **Size**: 145 lines / 9233 bytes — within budget.
- **Headings**: PASS — Goal / Phases & estimations / Routes / Open strategic questions / Mathlib gaps & new material, in the canonical order.
- **Per-iter narrative detected**: **yes** — extensive. Verbatim:
  - "Route C (genus-0 arm) is **PAUSED permanently** per USER 2026-05-28 standing directive."
  - "Carrier-soundness probe — FGAPicRepresentability | iter-198 verdict due"
  - "held in its iter-197 closure state (84 sorries / 0 axioms, 17-iter zero-axiom streak)"
  - "**Bottom-up execution priority** (USER 2026-05-28 standing directive)"
  - "**Reference-driven proofs** (USER 2026-05-28 standing directive)"
  - "next: broad Route A substrate sweep iter-202"
  - "analogist verdict iter-197 `STRUCTURAL_OK`"
  - "dispatched iter-196; verdict iter-198"

  These are not "context for the planner"; they are iter-by-iter narrative belonging in `iter/iter-NNN/plan.md`. The USER directive itself is fine as content (project-side rule), but the date and the cross-references to specific iters must be stripped.
- **Accumulation detected**: minor — A.1.a row remains in the Phases table with `0` iters left / `landed`. Drop the row once it is truly complete. The `Carrier-soundness probe` row is a decision point, not a phase; it belongs under `## Open strategic questions` (where it is also already mentioned).
- **Table discipline**: PASS — table columns and LOC `remaining · realized/it` shape are correct.
- **Appendix sections**: none.
- **Format verdict**: **DRIFTED** — heavy per-iter-narrative leakage. Restructure in-place this iter: replace iter-NNN references with phase-relative language ("post-probe verdict", not "iter-198 verdict due"), and move the date-stamped USER directives to a brief project-rule line ("Route C paused per USER directive; genus-0 arm uses dimension argument.").

## Infrastructure-deferral findings

### Deferred: Route C — Riemann–Roch chain (RR.1 / RR.2 / RR.3 / RR.4) + Rigidity_kbar + Genus0BaseObjects + AbelianVarietyRigidity

- **Required by goal**: yes — the Goal section asserts "End-state: zero inline `sorry`". Spot-check confirms 11 inline sorries in `H1Vanishing.lean`, 12 in `WeilDivisor.lean`, plus the strategy's own "84 sorries" figure across Route C files. All these files are imported into `AlgebraicJacobian.lean`. With Route C paused indefinitely the inline-sorry count never reaches zero.
- **Current plan for building it**: **none** — `Route C — PAUSED permanently`. The Phases table contains no Route C rows. The Mathlib-gaps section omits Route C.
- **Timeline**: absent.
- **Verdict**: **REJECT**. This is a goal weakening dressed as a strategic decision. The Goal cannot be reached with Route C paused unless one of the following is done and recorded in `STRATEGY.md` this iter:
  1. **Excise Route C files from the import tree** (remove imports from `AlgebraicJacobian.lean` and confirm the protected declarations still build). Then delete those files or move them under an off-tree directory. This is the cleanest fix.
  2. **Reopen Route C with a concrete iter / LOC budget** (even at low priority). The current "PAUSED permanently" is incompatible with "zero inline sorry".
  3. **Reframe Goal** to "zero inline sorry in the protected declarations' dependency cone, plus kernel-only axioms on the protected declarations themselves" — and document explicitly. This is a goal change and should be confirmed with USER (the directive does not authorize a goal change, only Route C pause).

  Note that (3) above is the *strategy's implicit reading*: pause Route C, close A, ship a green build that has `sorry` in files outside the dependency cone. But the strategy never says so. Either make it explicit or commit to closing Route C.

### Deferred: A.2.a (flattening stratification) + A.2.b (Quot / Grassmannian)

- **Required by goal**: partially — Pic representability (A.2.c, required by goal) classically uses Quot. The strategy claims the Cartier route bypasses both. See Route A.2.c CHALLENGE above.
- **Current plan for building it**: none — both labeled "bypassed via Cartier route".
- **Timeline**: absent.
- **Verdict**: **CHALLENGE** — confirm the Cartier route really represents `Pic_{C/k}` without using Quot, or restore A.2.b to the active plan. Cite a specific theorem (Kleiman §4.x lemma number, or FGA Explained Ch.9 §y.z) supporting the bypass. Until the bypass is anchored, the "infrastructure deferred" verdict stands.

## Alternative routes (suggested)

### Alternative: Murre / Mumford symmetric-product construction of Pic^d (post-Sym^g excision reversal)

- **What it looks like**: Build `Sym^d C` as a Mathlib `HilbertScheme` (or as the GIT quotient `C^d / S_d`); for `d ≥ 2g-1` the Abel–Jacobi map `Sym^d C → Pic^d C` is a projective bundle (`H⁰(C, L)` is locally free of constant rank `d-g+1` by RR); take the bundle quotient to define `Pic^d C` as a scheme. This is the curve-specific "easy" representability proof in FGA Explained Ch.9 §9.5 and Milne §III.4.
- **Why it might be cheaper or sounder**: for the *curve* case it is shorter than the general Kleiman §4 / Quot route. The strategy excised Sym^g but the excision is not load-bearing: the goal is the curve case, where Sym^d *is* the natural carrier.
- **What the current strategy may have rejected**: it labels Sym^g as "excised" without naming the cost trade. The `pic0-ker-deg-pivot` analogy weighs identity-component vs ker-deg but does not weigh Sym^d vs Cartier. Sym^d is the canonical FGA approach for curves; "Cartier route" is non-standard and lacks a reference.
- **Severity of the omission**: **major** — the strategy's current Pic-representability bypass is the weakest single claim in the document.

### Alternative: Zero-dim group scheme argument for genus-0 arm (already implicit; just name it)

- **What it looks like**: For genus 0, `dim_k H¹(C, O_C) = 0`. The tangent space of `Pic⁰_{C/k}` at the identity is `H¹(C, O_C)`, hence dim 0. A connected reduced group scheme of dim 0 over a field is `Spec k`. Then `Pic⁰_{C/k} = Spec k`, the Jacobian is trivial, and the Albanese UP is satisfied for the unique constant `k`-morphism. This avoids RR.4 / `genusZero_curve_iso_P1` entirely.
- **Why it might be cheaper or sounder**: it is what the strategy seems to intend ("terminal cluster Spec k") but states obliquely. Naming the lemma chain makes the Route-C-independence audit-checkable.
- **What the current strategy may have rejected**: nothing; this *is* the intended route. The omission is only of explanation.
- **Severity of the omission**: minor (clarity, not correctness).

## Sunk-cost flags

- `Persistent rationale: analogies/pic0-ker-deg-pivot.md` — this is the right way to record a decision (offload to an analogy file), but the line itself is fine; not a sunk-cost flag. No additional sunk-cost findings.

## Prerequisite verification

- `CategoryTheory.Functor.IsRepresentable`: VERIFIED (`Mathlib.CategoryTheory.Yoneda`).
- `CategoryTheory.Functor.IsRepresentable.mk'`: VERIFIED.
- "Cartier representability" of `Pic_{C/k}` (no Quot): **MISSING** — no Mathlib decl, no clear FGA / Kleiman theorem matches this name.
- Hilbert-polynomial open-and-closed decomposition (Kleiman `thm:Pphifin`) for relative Picard: MISSING in Mathlib (acknowledged by the strategy as project-side work, but the LOC estimate under A.3.vii is light).

## Must-fix-this-iter

- **Route C: REJECT** — 84 paused sorries are imported into the main module and contradict the Goal's "zero inline `sorry`". Either (a) excise the Route C files from the import tree and protected-decl dependency cone, (b) reopen Route C with a concrete iter / LOC budget, or (c) re-state the Goal to scope "zero inline sorry" to the protected-decl dependency cone and confirm with USER. Choose explicitly in `STRATEGY.md`.
- **Route A.2.c: CHALLENGE** — the "Cartier representability" bypass of Quot is not anchored to a citation. Cite the exact theorem (Kleiman §4.x or FGA Explained Ch.9 §y.z) or restore A.2.b (Quot) as an in-scope phase. The Sym^d / Abel–Jacobi alternative for curves (FGA Ch.9 §9.5) is a major-severity alternative to evaluate.
- **Route genus-0 witness: CHALLENGE** — make the lemma chain explicit (`dim Pic⁰ = genus = 0` ⇒ `Pic⁰ étale and connected` ⇒ `Pic⁰ = Spec k`) so the Route-C-independence of the genus-0 arm is audit-checkable. Replace "terminal cluster Spec k" with the actual Mathlib-style lemma name.
- **A.3.ii / A.3.vii effort honesty: CHALLENGE** — A.3.vii at ~80–200 LOC understates a scheme-level Hilbert-polynomial construction. Widen estimate to ~300–600 LOC or split into sub-phases.
- **Carrier-soundness probe abort criterion: CHALLENGE** — name the specific declarations whose `#print axioms` decides the verdict, name the expected kernel-only axiom triple, and name the rollback commit / sha. "If still showing silent `sorryAx`, revert" is not actionable as written.
- **Format: DRIFTED** — strip per-iter-narrative phrases (`iter-198 verdict due`, `iter-197 closure state`, `17-iter zero-axiom streak`, `next: broad Route A substrate sweep iter-202`, the date-stamped USER directive cross-references). Replace with phase-relative language. Drop the A.1.a "landed" row and the Carrier-soundness probe row from the Phases table; the probe already appears under Open strategic questions, which is its right home.
- **Infrastructure-deferral: A.2.a + A.2.b** — see A.2.c CHALLENGE.

## Overall verdict

**CHALLENGE.** The bottom-up Route A execution order is mathematically sound (Priority 1 roots A.4.a, A.4.b, A.1.a are genuinely ungated; Mathlib prerequisites for those roots verify), and the Pic⁰-via-degComp pivot (`pic0-ker-deg-pivot.md`) remains defensible on a fresh reading: it trades a parked Stacks 04KU/04KV gap for a Pphifin gap that the strategy already plans to build. The carrier-soundness probe (Option A, `Functor.IsRepresentable`-style) is also sound on the math; only its abort criterion needs sharpening. However, **the strategy defers Route C, which is required for the stated goal** — 84 inline sorries in Route C files imported by `AlgebraicJacobian.lean` cannot coexist with the Goal's "zero inline `sorry`" end-state; the planner must either excise those files from the import tree, reopen Route C with a concrete budget, or formally amend the Goal. **The strategy also defers A.2.a + A.2.b via an unnamed "Cartier representability" route**, which has no literature anchor and contradicts Kleiman §4's Quot-based representability proof; the planner must either cite the bypass theorem or restore Quot to the plan. Finally, **STRATEGY.md is format-DRIFTED** by per-iter-narrative leakage; restructure in-place this iter.
