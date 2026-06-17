# Blueprint Writer Directive

## Slug
jacobian-genus0-reframe

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Strategy context

The project has made a strategic decision that this chapter must now reflect. The
witness OBJECT for the positive-genus arm is `Pic⁰_{C/k}` (a dim-`g` abelian
variety), built by **Route A (Picard scheme via FGA)** — this is the project's
critical path and is mandatory regardless of anything else (the object must be a real
dim-`g` abelian variety even when `C(k)=∅`).

The **genus-0 arm is DECOUPLED from Route A's representability**. Its witness OBJECT
is the trivial `J = Spec k` (the `genusZeroWitness` skeleton already has 6/7 fields
closed). What remains for genus-0 is a single rigidity STATEMENT, packaged as
`thm:rigidity_over_kbar`: over `k̄`, a genus-0 curve is `≅ ℙ¹`, and any pointed
`f : C → A` (`A` a smooth proper group scheme) killing `P` is constant.

**Crucial correction this chapter must absorb:** the genus-0 arm needs a rigidity
LEMMA, NOT the Pic⁰ representability engine. The current chapter prose incorrectly
routes genus-0 through the differential `df = 0` argument (which would require Serre
duality — refuted as the live path) and/or implies the full Picard scheme is needed
for genus-0. Both framings are wrong and must be re-pointed.

The genus-0 rigidity proof route is now COMMITTED to (c), with (b)/(a) as fallbacks:
- **(c) [COMMITTED — feasibility CONFIRMED]** a char-free AV-rigidity lemma: "every
  morphism from a genus-0 curve (`ℙ¹`) to an abelian variety is constant", via the
  **theorem of the cube → rigidity lemma**. CONFIRMED feasible from Milne, *Abelian
  Varieties* (`references/abelian-varieties.pdf`, now in tree): Theorem of the Cube
  (§I.5) → Rigidity Theorem 1.1 (§I.1, doc p.8 / PDF p.14) → Theorem 3.2 (rational map
  from a nonsingular variety to an AV is everywhere-defined; §I.3 doc p.15 / PDF p.23)
  → **Proposition 3.10** (any rational map from a unirational variety, incl. `ℙ¹`, to
  an AV is constant; §I.3 doc p.20 / PDF p.26). This chain uses NEITHER `H^0(Ω)=0` /
  Serre duality NOR the Picard representability. `rigidity_over_kbar` IS exactly "map
  into an AV is constant" (Prop 3.10), so the `df=0` framing was a red herring of the
  chart route. Reuses the rigidity machinery the positive-genus Albanese UP needs
  anyway (Milne §III.6, Prop 6.1/6.4), decoupled from the FGA representability monster,
  char-free.
- **(b)** byproduct of the engine: once Route A exists, `Alb(genus-0)=Pic⁰(ℙ¹)=0`,
  so `f` factors through `Spec k̄`. Free, but couples genus-0 to A.2 representability.
- **(a) FALLBACK** the differential route: `df=0` via {`Ω_A` cotangent-triviality +
  Serre duality `H^0(C,Ω_C)=0`}, reusing the closed chart-algebra envelope (which
  supplies only the converse `df=0 ⟹ constant`). Off the critical path; kept in tree;
  carries a char-`p` gap.

## Required content

1. **Re-point the genus-0 framing OFF the differential `df=0` route.** At every
   location the blueprint-review flagged, replace "genus-0 routes through the
   differential `rigidity_over_kbar`/`df=0` keystone (gated on the cotangent-vanishing
   pile / Serre duality)" with the corrected framing: "the genus-0 witness object is
   the trivial `Spec k`; the remaining content is the rigidity STATEMENT
   `thm:rigidity_over_kbar`, decoupled from Pic⁰ representability; its proof route is
   under determination among candidates (c)/(b)/(a) above, with (c) the lead." The
   specific locations (verify against the live file; line numbers approximate):
   - `def:genusZeroWitness` (~lines 452–498): the `isAlbaneseFor` factorisation
     currently reduces to `rigidity_over_kbar` over `k̄`. Keep that reduction (it is
     correct — genus-0 still uses `rigidity_over_kbar`), but correct any prose that
     describes `rigidity_over_kbar`'s OWN proof as the differential/Serre route or as
     requiring the cotangent-vanishing pile; state instead that its proof route is the
     decoupled rigidity lemma (route c lead) and is NOT the differential route.
   - the genus-0 sub-case **C.2.d** (~line 395).
   - the Mathlib-infrastructure summary **(γ)** (~line 438): currently "genus-0 arm
     gated on `rigidity_over_kbar` + shared cotangent-vanishing pile". Re-point:
     genus-0 needs only the rigidity statement via the AV-rigidity lemma, decoupled
     from both the cotangent pile and representability.
   - **Layer I** (~line 539).
   Do NOT delete the differential/chart-algebra material; demote it to "fallback
   route (a), off the critical path, retained in tree" wherever it appears as the
   live path.

2. **State that Route A is the critical path and is mandatory for the positive-genus
   OBJECT.** Make explicit (in the infrastructure summary and `def:positiveGenusWitness`
   surroundings) that the FGA Pic⁰ engine is required unconditionally for the
   positive-genus object, independent of the genus-0 route choice.

3. **Add a rigidity-lemma block for route (c)** (the committed genus-0 path): a
   `theorem`/`lemma` block stating "every morphism from a smooth proper geometrically
   irreducible genus-0 curve over `k̄` to an abelian variety (smooth proper geom-irred
   group scheme), sending a `k̄`-point to the identity, is constant", with a proof
   sketch following the Milne chain: theorem of the cube → Rigidity Theorem 1.1 →
   Theorem 3.2 (rational map nonsingular→AV extends) → Proposition 3.10
   (unirational→AV constant). **Citation discipline — the source IS on disk:**
   `references/abelian-varieties.pdf` (Milne, "Abelian Varieties", v2.00) is present.
   OPEN it with the Read tool (it supports PDFs via the `pages` parameter; the relevant
   pages are PDF p.14 = Rigidity Thm 1.1, PDF p.21 = Theorem of the Cube §I.5, PDF p.23
   = Thm 3.2, PDF p.26 = Prop 3.10, PDF p.110–111 = Albanese Prop 6.1/6.4). Read those
   pages, then supply the mandatory `% SOURCE:` (with `(read from
   references/abelian-varieties.pdf)`) + verbatim `% SOURCE QUOTE:` (the statement) +
   `% SOURCE QUOTE PROOF:` (the proof) lines, copied character-for-character from the
   PDF. NEVER write a citation from memory; if a specific page won't render, quote only
   what you can actually read and flag the rest as not-yet-transcribed.

## Out of scope

- Do NOT do the full Route A build-out (turning the A.1–A.4 sketch into prover-ready
  `\lean{...}`-targeted blocks). That is a separate, larger writer task for a later
  round once the AV source is digested. You MAY note `RelativeSpec` (A.1) as the named
  smallest entry point for that future build-out, but do not attempt to flesh A.1–A.4
  into prover-ready statements this round.
- Do NOT edit any chapter other than `Jacobian.tex`. The parallel route-reframe of
  `RigidityKbar.tex` (the "commits to neither route" paragraph) and `AbelJacobi.tex`
  (classical-description prose) are separate writer tasks — flag any inconsistency you
  notice in "Notes for Plan Agent" but do not fix it here.
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed elsewhere).

## References

- `references/kleiman-picard.pdf` (Kleiman, "The Picard scheme") — §5 `Pic⁰`; backs
  the Route A positive-genus object and `Pic⁰(genus-0)=0`.
- `references/abelian-varieties.pdf` (Milne, "Abelian Varieties", v2.00) — IN TREE.
  The rigidity-lemma chain for the route-(c) block: Rigidity Thm 1.1 (PDF p.14),
  Theorem of the Cube §I.5 (PDF p.21), Thm 3.2 (PDF p.23), Prop 3.10 (PDF p.26),
  Albanese Prop 6.1/6.4 (PDF p.110–111). Read via the Read tool's `pages` parameter.
  Pointer: `references/abelian-varieties.md`.

## Expected outcome

`Jacobian.tex`'s genus-0 framing no longer claims the differential `df=0`/Serre route
is the live path; it presents the genus-0 arm as a decoupled rigidity statement
(object `Spec k`) with the three ranked proof routes (c lead / b / a fallback), and
states Route A as the mandatory critical path for the positive-genus object. A
route-(c) rigidity-lemma block is present with a properly-sourced (or honestly
flagged-as-pending) citation. The differential/chart-algebra material is retained but
demoted to fallback. No Route A prover-ready build-out is attempted this round.
