# Blueprint Writer Directive

## Slug
weildivisor-doc-updates

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Strategy context

RR.1 (Weil divisors on a smooth curve) is the genus-0 RR-bridge entry
that also feeds A.4.a's codim-1 surface API on the Route-A arm. The
chapter landed iter-172; iter-173/174 added pins. The iter-174 lean-vs-blueprint-checker
`weildivisor-iter174` reported **2 MAJOR writer-side findings** that need
to be closed THIS plan-phase before Lane D iter-175 opens the body lane
on `RationalMap.order`:

1. **`def:divisor_closed_point` "Lean signature scope" paragraph
   (L330–340 of the chapter) does NOT document the iter-174 junk-branch
   convention** actually adopted by the Lean. The Lean `ofClosedPoint`
   is junk-defined: `if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩
   1 else 0`. The chapter currently describes a "typeclass-threaded
   promotion in proof body" plan that the iter-174 Lean did not take.
   Also: the chapter has not pinned the two bridge equation lemmas
   `ofClosedPoint_eq_single` (L186-189) and `ofClosedPoint_eq_zero`
   (L195-198) that the iter-174 Lean exposes as the consumer API for
   the junk-branch behavior.

2. **`def:order_at_point` block under-specifies the iter-175 body
   target** (`RationalMap.order`). No Mathlib API pinning, no
   junk-on-`f = 0` convention statement, no "Lean signature scope"
   paragraph. The iter-175 plan-phase is dispatching an analogist
   (`mathlib-analogist dvr-rationalmap-order`) to surface the right
   Mathlib API path; you should incorporate the analogist's findings
   into the chapter prose.

## Required content

Two targeted edits:

### Edit 1 — `def:divisor_closed_point` junk-branch documentation

Locate the chapter's `def:divisor_closed_point` block (around L330 of
the chapter). Add a "Lean signature scope" paragraph documenting:

- The Lean `Scheme.WeilDivisor.ofClosedPoint` signature takes `(P : C)
  (hP : IsClosed ({P} : Set C))` and is **junk-defined** outside the
  `Order.coheight P = 1` regime: on the off-branch (where `P` is not a
  codim-1 point — e.g., `P` is the generic point or a higher-codim
  closed point), `ofClosedPoint` returns `0 ∈ Div(C)`.
- This convention lets the Lean signature avoid threading the
  `[OneDimensional X]` / `[IsIntegral X]` typeclass payload at the
  declaration head; the well-definedness consumer must use the bridge
  equation lemmas:
  - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` —
    states `ofClosedPoint P hP = Finsupp.single ⟨P, h⟩ 1` when
    `h : Order.coheight P = 1`.
  - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` —
    states `ofClosedPoint P hP = 0` when `Order.coheight P ≠ 1`.
- On the "intended regime" (one-dimensional integral scheme `X`, `P` a
  closed point), the chapter's mathematical statement
  `[P] := 1·P ∈ Div(X)` is recovered by `ofClosedPoint_eq_single`
  combined with the chain `IsClosed {P} → Order.coheight P = 1` that
  the prover threads inside the consumer.

Add `\lean{...}` blocks for `ofClosedPoint_eq_single` /
`ofClosedPoint_eq_zero` as separate lemma blocks adjacent to
`def:divisor_closed_point` so the blueprint-doctor's pinned-decl graph
picks them up. Suggested labels:
`lem:ofClosedPoint_eq_single`, `lem:ofClosedPoint_eq_zero`.

### Edit 2 — `def:order_at_point` Lean-signature-scope paragraph

Locate the chapter's `def:order_at_point` block. Add a "Lean signature
scope" paragraph documenting (per the iter-175 analogist consult, which
should land BEFORE you start — read `analogies/dvr-rationalmap-order.md`
first, then incorporate its findings):

- The Lean `Scheme.RationalMap.order` signature is
  `[IsIntegral X] (Y : X.PrimeDivisor) (f : X.functionField) : ℤ`,
  with NO `f ≠ 0` hypothesis (junk-on-`f = 0`).
- The Mathlib API path the body uses (replace `<NAMES>` with whatever
  the analogist returned): probably the DVR extraction from the local
  ring at `Y.point` via `<NAMES>`, then `<NAMES>.addVal` for the
  valuation, then extension to the fraction field via `<NAMES>` (or
  the unbundled `v(f/g) := v(f) − v(g)` if Mathlib has no canonical
  extension at this commit).
- Junk convention: `order Y 0 := 0` (or whatever the analogist
  recommends — `0` is the natural sentinel since divisors with a `0`
  coefficient drop from the `Finsupp`'s support).
- Cite the "regular-in-codim-1 ⟹ local ring at `Y.point` is a DVR" step
  (Mathlib instance / lemma name from the analogist's recipe; if absent
  upstream, mark as in-tree gap-fill).

If the analogist consult also surfaces a junk-branch concern for
`Order.coheight` on the `PrimeDivisor` carrier, document that too.

## Out of scope

- Do NOT change the `\lean{...}` pin on `def:order_at_point` or
  `def:divisor_closed_point`.
- Do NOT rewrite the chapter's general motivation prose or the layered
  typeclass discipline paragraphs at the chapter top.
- Do NOT touch `\leanok` or `\mathlibok` markers.
- Do NOT edit other chapters.
- Do NOT add un-related pins.
- Do NOT speculate Mathlib API names that you cannot verify; if the
  analogist report says "in-tree gap-fill" for a step, faithfully
  record that.

## References

- `analogies/dvr-rationalmap-order.md` (will land this plan-phase via
  `mathlib-analogist dvr-rationalmap-order` — wait for it before
  starting Edit 2; Edit 1 can proceed immediately).
- `references/hartshorne.pdf` II.6 (divisors), II.6.10 (degree of
  principal divisor is zero), IV.1 (curves).

## Expected outcome

After your edit:
- `def:divisor_closed_point` has a "Lean signature scope" paragraph
  documenting the junk-branch convention and references the two bridge
  equation lemmas.
- Two new lemma blocks `lem:ofClosedPoint_eq_single` and
  `lem:ofClosedPoint_eq_zero` pin the bridge equations.
- `def:order_at_point` has a "Lean signature scope" paragraph naming
  the Mathlib API path (per analogist), the junk-on-`f = 0` convention,
  and any in-tree gap-fill steps.
- Iter-174 LVB `weildivisor-iter174` MAJOR findings are closed.
- Chapter remains complete + correct; HARD GATE clearable for Lane D
  iter-175 body lane on `RationalMap.order`.
