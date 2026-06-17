# Strategy Auditor Directive

## Slug
rrfree206

## Iter
206

## The strategic question to audit

The project's stated goal is the existence of a Jacobian/Albanese object
for a smooth proper geometrically irreducible curve `C/k`, routed through
`J := Pic⁰_{C/k}` (Kleiman §4–§5 + Nitsure §5 + Milne III §6). The project
currently treats **Riemann–Roch (Route C)** as a dependency of
`Pic_{C/k}` representability (the node A.2.c), and Route C is PAUSED by a
USER standing directive — which makes the unconditional goal unreachable
in the genus ≥ 1 case until the pause lifts.

**Audit this claim**: is `Pic_{C/k}` (or specifically `Pic⁰_{C/k}`)
representability genuinely dependent on Riemann–Roch, or is it RR-free?
Concretely, validate or refute each of the following against the actual
source PDFs/TeX:

1. **(RR-free bare representability)** Does the FGA/Grothendieck–Nitsure
   Quot-scheme construction of `Pic_{X/S}` representability invoke
   Riemann–Roch anywhere, or is bare representability of the Picard
   functor classically RR-free (RR entering only later, e.g. to compute
   dimensions or identify components by degree)? Read **Nitsure,
   "Construction of Hilbert and Quot Schemes"** (the Quot/representability
   engine) and **Kleiman, "The Picard scheme" §4** (existence).

2. **(degree-0 component without RR)** The project defines
   `Pic⁰_{C/k} := PicScheme.degComp C 0` (the degree-0 component, Kleiman
   §6, Hilbert-polynomial open-closed decomposition). Identifying a
   component *by its degree* uses RR (the degree↔Hilbert-poly link, RR.1).
   Would defining `Pic⁰` instead as **the connected component through the
   trivial class `[O_C]`** (Kleiman §6 `ex:curves` / Milne III §1, the
   identity component) avoid the RR-dependent degree identification while
   yielding the SAME object for a smooth proper geom-integral curve?
   Read **Kleiman §6** (`ex:curves`, `rmk:curves`) and **Milne III §1
   (Thm 1.6)**.

3. **(downstream RR dependence)** Even if representability is RR-free, do
   the *downstream* nodes the project needs — the Albanese universal
   property (Milne III §6, Prop 6.1/6.4) and the Pic^d / divisor-map
   construction (Kleiman §5 + Milne III §4, the `Sym^d`/Abel map route) —
   independently require Riemann–Roch (e.g. via the genus formula, or
   `Sym^d C → Pic^d` surjectivity for `d ≥ 2g-1`)? Read **Milne III §4
   and §6** and **Kleiman §5**.

The decision at stake: if (1) holds and (2) yields an RR-free `Pic⁰`, and
(3) shows the Albanese UP can be reached RR-free (or only the genus
formula needs RR), then the project may be able to **cut Riemann–Roch off
the genus ≥ 1 critical path**, reaching the unconditional goal without
lifting the Route C pause. That is a major re-route — I must not commit it
on my own recollection; your audit against the actual sources is the gate.

## What to read (sources in references/)
- `references/nitsure-hilbert-quot.pdf` (and `-src/*.tex`) — Quot/Hilbert
  construction; representability engine.
- `references/kleiman-picard.pdf` (and `-src/*.tex`) — §4 existence, §5
  Pic⁰/Jacobian (pp.36–51), §6 ex:curves/rmk:curves.
- `references/abelian-varieties.pdf` (Milne) — III §1 (Thm 1.6 identity
  component), III §4 (Sym^d/Abel), III §6 (Prop 6.1/6.4 Albanese UP).

Use the `.md` pointer cards only to locate sections; base every finding on
the raw PDF/TeX text and quote the operative sentences.

## What to report
For each of the three sub-questions: VALIDATED / REFUTED / PARTIAL, with
the verbatim source sentence(s) that decide it and the section/page. Then
a bottom-line: can RR be cut from the genus ≥ 1 critical path for the
*representability + Pic⁰-identification* layer (yes/no/partial), and which
downstream nodes (if any) still force RR. Flag any silent assumption the
sources make that the project's RR-free re-route would violate (e.g. a
properness/projectivity hypothesis, a `Sym^d` surjectivity that needs
`d ≥ 2g-1`, a base-point/section requirement).
