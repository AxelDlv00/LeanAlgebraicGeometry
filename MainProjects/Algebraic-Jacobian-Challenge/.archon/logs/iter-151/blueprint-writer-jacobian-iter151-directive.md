# Blueprint Writer Directive

## Slug
jacobian-iter151

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Strategy context
This chapter backs `AlgebraicJacobian/Jacobian.lean` — the Albanese/Jacobian
existence theorems, with `nonempty_jacobianWitness` the foundational existence
gap closed (eventually) by Route A (Picard scheme via FGA, off-critical-path).
The iter-151 blueprint review found the chapter mathematically complete and
correct but noted its Route-A declarations cite sources only loosely in prose
(FGA 232, Hartshorne III.4, "FGA Explained Ch. 9") with NO verbatim citation
block. The genuine FGA Explained sources are now bundled in-tree
(`references/kleiman-picard.pdf` + LaTeX source, and
`references/nitsure-hilbert-quot.pdf`). This round adds verbatim source-citation
blocks for the Route-A declarations.

## Required content

### Add verbatim source-citation blocks (scope: ~5 declarations)
For each, add `% SOURCE:` (Kleiman result label + the local file read from),
`% SOURCE QUOTE:` (VERBATIM statement copied from
`references/kleiman-picard-src/kleiman-picard.tex`, character-for-character,
LaTeX macros and all — do NOT paraphrase), and a visible
`\textit{Source: Kleiman, The Picard Scheme, <result>.}` line. Open the bundled
source and copy the exact `\begin{thm}/\begin{prp}/\begin{rmk}` body.

- `thm:nonempty_jacobianWitness` (and/or `def:positiveGenusWitness`) — the
  curve Jacobian exists as a projective abelian scheme. Source:
  `kleiman-picard.tex` **`ex:jac`** (near L3911: "the generalized Jacobians …
  form a smooth quasi-projective family of relative dimension `p_a` … projective
  iff `X/S` smooth") and **`rmk:Jac`** (near L3990: `J := Pic⁰_{X/S}` exists and
  is a projective abelian scheme).
- `thm:Jacobian_proper` / properness — Source: `prp:P0` (near L3661: Pic⁰ is
  closed in Pic and proper over S when fibres are complete).
- `thm:Jacobian_smooth_genus` / smoothness + dimension — Source: `cor:sm`
  (near L3421: `dim Pic = dim H¹(O_X)`, smooth iff smooth at 0) and `cor:ch0`
  (near L3442: char 0 ⟹ smooth) and `prp:P0` (smooth over reduced S).
- `thm:Jacobian_geomIrred` / geometric irreducibility + the open-closed
  finite-type identity component — Source: `lem:agps` (near L2851: G l.f.t. over
  a field is separated; smooth if it has a geom-reduced open; `G⁰` is open-closed
  finite-type geom-irreducible and commutes with field extension) and `prp:pic0`.
- `def:IsAlbanese` — the Albanese universal property is classical
  (Serre / Lang), NOT in the bundled sources. Do NOT fabricate a quote: add only
  `% SOURCE: Serre/Lang, Albanese variety (classical; verbatim text not
  retrieved)` and a visible `\textit{Source: classical (Serre/Lang).}` line, no
  `% SOURCE QUOTE:`. (If `kleiman-picard.tex` `rmk:Alb` near L3960 covers the
  Albanese map well enough, you MAY quote that verbatim instead — your call,
  read it first.)

The existence ENGINE (Quot/Hilbert) lives in
`references/nitsure-hilbert-quot.pdf` (§4 flattening, §5 Quot construction); if
the chapter has a declaration explicitly about Quot/Hilbert representability,
cite Nitsure there — otherwise a single prose pointer to Nitsure for the A1
sub-piece suffices.

## Out of scope
- Do NOT restructure the Route A / Route B decomposition or change any proof
  sketch math; this is a citation-only round.
- Do NOT edit any other chapter.
- Do NOT add or remove `\leanok` / `\mathlibok` markers.
- Do NOT fabricate quotes — flag any unavailable source as not-retrieved.

## References
- `references/kleiman-picard-src/kleiman-picard.tex` — quote from here:
  `ex:jac` (L3911), `rmk:Jac` (L3990), `prp:P0` (L3661), `cor:sm` (L3421),
  `cor:ch0` (L3442), `lem:agps` (L2851), `rmk:Alb` (L3960).
- `references/kleiman-picard.md` — the deep section→page map.
- `references/nitsure-hilbert-quot.pdf` / `.md` — Quot/Hilbert engine (A1).
- `references/summary.md` — index.

## Expected outcome
The Route-A declarations of `Jacobian.tex` each carry a verbatim
`% SOURCE QUOTE:` copied from `kleiman-picard.tex` with a visible
`\textit{Source: …}` line, the classical Albanese definition is honestly flagged
(no fabricated quote), and Nitsure is cited for the A1 Quot/Hilbert engine.
