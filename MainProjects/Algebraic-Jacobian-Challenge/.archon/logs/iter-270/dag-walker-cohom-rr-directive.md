# DAG Walker Directive

## Slug
cohom-rr

## Seed
thm:riemannRoch_genus_zero

## Strategy context
The genus of a smooth proper curve (`def:genus`, consumed by the project spine)
is defined through the Riemann–Roch machinery, which rests on a large
sheaf-cohomology infrastructure: Čech cohomology with k-module coefficients, the
Mayer–Vietoris long exact sequence, the structure sheaf as a sheaf of k-modules
/ abelian groups, higher direct images, and flat base change. This is the
LARGEST disconnected region of the blueprint: ~120 isolated nodes across the
Cohomology and RiemannRoch chapters. The mathematics and proofs are already
written in these chapters; what is missing is the `\uses{}` wiring tying them
into one cone under the RR genus head.

## Depth / scope
**Your write domain is ONLY the chapters matching `Cohomology_*.tex` and
`RiemannRoch_*.tex`.** Three parallel walkers own the other regions — do NOT
edit Jacobian/AbelJacobi/Genus, Rigidity, Picard, or Albanese chapters.

Walk UP from `thm:riemannRoch_genus_zero` and from the other RR heads
(`thm:euler_char_eq_deg_plus_one_minus_genus`, and the RR.* / H1-vanishing /
WeilDivisor / OCofP / OcOfD / RationalCurveIso top declarations) and make the
whole Cohomology+RiemannRoch cone complete:

1. For each isolated node in your chapters (use
   `archon dag-query ancestors --node thm:riemannRoch_genus_zero --json` and
   `leandag show isolated --json` filtered to your chapters), read its statement
   and proof and add the `\uses{}` edges its proof actually invokes — both
   intra-chapter and to other Cohomology/RiemannRoch chapters you own.
2. The big internal clusters to wire: the Mayer–Vietoris long-exact-sequence
   family (`Cohomology_MayerVietoris.tex`, ~56 nodes), the sheaf-of-k-modules /
   sheafification / Ext / structure-sheaf family
   (`Cohomology_StructureSheafModuleK.tex`, ~46 nodes), structure sheaf as
   abelian groups (`Cohomology_StructureSheafAb.tex`), higher direct images and
   flat base change, and the RR formula chain
   (Euler characteristic → skyscraper H^0/H^1 → RR formula → genus-zero RR).
3. Connect the RiemannRoch layer DOWN to the Cohomology layer: RR statements
   about H^0/H^1 dimensions `\uses` the cohomology definitions that compute
   them.
4. Where the cone bottoms out at a result Mathlib provides as-is (e.g. snake
   lemma / long exact sequence of a short exact sequence of complexes,
   sheafification existence, Ext functoriality), and there is NOT already a
   project block proving it, you MAY author a Mathlib dependency anchor
   (statement + `\lean{<real Mathlib decl>}` + `\mathlibok` + `\textit{Provided
   by Mathlib.}`) — but ONLY if you can name the genuine Mathlib declaration;
   otherwise leave it and report it. Many of these nodes are already
   "proved directly in Lean" (effort 0) — for those just add the `\uses{}`
   edges; do not touch their proof state.

**Boundary rule:** `def:genus` (Genus.tex) is owned by the Backbone walker — it
will add the edge from `def:genus` down to your RR head. You do NOT edit
Genus.tex. Stop at the top of your region; record the handoff.

For any node in your chapters with a real statement but no `\lean{}` and not a
`\begin{remark}`, add a placeholder `\lean{AlgebraicGeometry.TODO.<name>}`.

Do NOT add `\leanok`. Do NOT invent new mathematics — the proofs are already
written; you are transcribing dependencies. If a node genuinely has no proof and
no Lean (∞), report it under "Could not complete"; do not fabricate.

## References
- `references/stacks-coherent.md` (Stacks ch.30, tag 02KH flat base change of
  R^i f_*) — if you need to cite flat base change.
- `references/stacks-varieties.md` (tag 0BUG, H^0(X,O) lemma) — if you cite the
  global-sections / structure-sheaf facts.
  Cite verbatim from the local files only; do not quote from memory.
