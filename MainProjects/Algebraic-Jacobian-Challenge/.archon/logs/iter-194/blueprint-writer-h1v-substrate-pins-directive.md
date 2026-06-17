# Blueprint Writer Directive — H1Vanishing substrate pins (WD-1)

## Slug

h1v-substrate-pins

## Chapter

`blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

## Problem

The iter-193 prover landed two named substrate helpers in the Lean
file `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`:

1. `ext_succ_eq_zero_of_injective_of_lower_zero` (at L256-287 in
   `H1Vanishing.lean`).
2. `IsFlasque.cokernel_of_shortExact_flasque_flasque` (at L? in
   `H1Vanishing.lean` — grep for `cokernel_of_shortExact_flasque_flasque`).

Both helpers are essential substrate for closing
`HModule_flasque_eq_zero` (Hartshorne III.2.5). However, **neither has
a `\lemma` block with `\lean{...}` pin in the blueprint chapter**. The
iter-194 blueprint-reviewer flagged this as a HARD GATE blocker for
Lane H (writer directive WD-1).

## Scope

Add **two `\lemma` blocks** to `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`,
each with a `\lean{...}` pin and prose that summarises the Lean
declaration's statement.

### Lemma 1: `ext_succ_eq_zero_of_injective_of_lower_zero`

Read the Lean declaration at
`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (grep for the
declaration name to find the exact line); extract:
- The full Lean type signature (including all hypotheses).
- The proof's mathematical content (the docstring already summarises it).

Produce a blueprint `\lemma` block of the shape:

```latex
\begin{lemma}
[Ext-succ vanishes from injective leftmost + lower Ext zero]
  \label{lem:ext_succ_zero_of_injective_lower_zero}
  \lean{AlgebraicGeometry.Scheme.ext_succ_eq_zero_of_injective_of_lower_zero}
  % <verify the exact namespace by reading the Lean declaration>
  \uses{lem:HModule_def}
  Given a short exact sequence ... [prose statement in project's
  notation; ~5-8 lines]
\end{lemma}
```

**Verify the Lean namespace by reading the actual declaration**
(`grep -n "ext_succ_eq_zero_of_injective_of_lower_zero" AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
+ check the surrounding `namespace ... end namespace` blocks).

### Lemma 2: `IsFlasque.cokernel_of_shortExact_flasque_flasque`

Same pattern — add a `\lemma` block:

```latex
\begin{lemma}
[Cokernel of a short exact sequence of flasque sheaves is flasque]
  \label{lem:flasque_cokernel_short_exact}
  \lean{AlgebraicGeometry.Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque}
  % <verify the exact namespace by reading the Lean declaration>
  \uses{def:flasqueSheaf}
  Let $0 \to F_1 \to F_2 \to F_3 \to 0$ be a short exact sequence of
  sheaves of $\mathcal{O}_C$-modules with $F_1$ and $F_2$ flasque.
  Then the cokernel $F_3$ is flasque.
\end{lemma>
```

### Placement

Place both blocks **before** the proof of `lem:HModule_flasque_eq_zero`
(Hartshorne III.2.5 body, since these helpers are consumed there).
Specifically, locate the section heading where the
`HModule_flasque_eq_zero` chain is documented, and add the two blocks
just before that.

If the chapter has an "Out of Scope" or "Substrate" annex section that
currently says "project-side ancillary lemmas sketched inside the
proof but not given their own pin", **delete that disclaimer** (the
iter-194 fix removes it).

### Source citations

Both helpers are project-bespoke (not directly cited from Hartshorne
beyond the broader II Ex 1.16 / III Lemma 2.4 context). Source comment
format:

```latex
% SOURCE: Project-bespoke substrate helper for Hartshorne II.1.16/III.2.5
% chain (iter-193 prover-side construction).
% SOURCE QUOTE: (project-original; no external verbatim text)
\textit{Source: project-bespoke iter-193 substrate.}
```

No verbatim external quote is needed for project-bespoke material.

### Out of scope

- Do NOT add `\leanok` markers anywhere — that is owned by the
  deterministic `sync_leanok` phase between prover and review.
- Do NOT modify the body of `lem:HModule_flasque_eq_zero` or its proof
  block — those are pre-existing and correct.
- Do NOT add prose for the two other named substrate sorries
  (`shortExact_app_surjective` Hartshorne II Ex 1.16(b) +
  `injective_flasque` Hartshorne III Lemma 2.4) — those are separate
  iter-195+ work.

## References

- Hartshorne II Ex 1.16(b) (Stacks 09Z6) for the higher-Ext vanishing
  context.
- Hartshorne III Lemma 2.4 for flasque-cokernel.
- Lean source: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
  (grep for the declaration names).

## Verification

After your edits, run `lake build AlgebraicJacobian.RiemannRoch.H1Vanishing`
to confirm the Lean file still compiles (no — the blueprint edit doesn't
affect Lean, but this confirms baseline). The deterministic
`sync_leanok` phase between prover and review will check that the new
`\lean{...}` pins match actual Lean declarations and mark `\leanok` if
the bodies are closed (these are axiom-clean per iter-193 review).

## Expected outcome

After this writer dispatch, the H1Vanishing chapter contains 2 new
`\lemma` blocks with `\lean{...}` pins. The iter-194 blueprint-reviewer
HARD GATE blocker for Lane H is resolved. Iter-194 plan-phase may
re-dispatch the scoped blueprint-reviewer for `RiemannRoch_H1Vanishing.tex`
alone, and if it passes, Lane H may be added back to iter-194 prover
dispatch via the same-iter fast path.

If the same-iter fast path is not exercised (e.g., budget constraints
this iter), Lane H is auto-released for iter-195's mandatory
blueprint-reviewer dispatch.
