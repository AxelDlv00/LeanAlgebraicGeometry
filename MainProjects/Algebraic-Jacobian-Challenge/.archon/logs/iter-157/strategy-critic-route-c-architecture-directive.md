# Strategy Critic Directive

## Slug
route-c-architecture

## What to read (and ONLY this)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim — the current strategy).
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` (the reference index).
- The blueprint chapter list + one-line topics below.
- The project goal below.

Do NOT read iter sidecars, PROGRESS.md, task_pending/done, prover results, or review
reports. Your value is a fresh mathematician's read of the strategy, not the project's
momentum.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: construct, for a smooth proper
geometrically irreducible curve `C` over an arbitrary field `k` (NO `C(k) ≠ ∅`
hypothesis on the protected signature), an Albanese/Jacobian group-scheme object `J`
together with its universal property `isAlbaneseFor` (every pointed morphism from `C`
to a smooth proper group scheme factors uniquely through `J`). End-state: zero inline
`sorry`, kernel-only axioms. The spine is pointed-vs-unpointed; the witness object is
real on both arms (genus-0 object = trivial `Spec k`; positive-genus object =
`Pic⁰_{C/k}`, a dim-`g` abelian variety, required even when `C(k)=∅`).

## Blueprint chapters (title / topic)
- `Cohomology_*` — sheaf/cohomology infrastructure (H⁰/H¹ of `O_C`, Mayer–Vietoris).
- `Differentials.tex` — Kähler differentials infrastructure.
- `Genus.tex` — arithmetic genus `dim_k H¹(C,O_C)`.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — group-object cotangent material (off-path).
- `RigidityKbar.tex` — genus-0 rigidity over `k̄` (`rigidity_over_kbar`) + chart-algebra
  envelope; currently disclosed as a gated NAMED GAP; differential/`df=0` route demoted
  to fallback (a).
- `Rigidity.tex` — scheme-level rigidity packaging (`ext_of_eqOnOpen`).
- `Jacobian.tex` — the witness construction (`nonempty_jacobianWitness`,
  `genusZeroWitness`, `positiveGenusWitness`) + the route-(c) AV-rigidity stack blocks
  (theorem of the cube → rigidity → rational-map-extends → unirational⟹constant →
  genus0-curve-to-AV), at statement+Milne-citation level.
- `AbelJacobi.tex` — Abel–Jacobi map / functoriality (`Jacobian.ofCurve`).

## New since last strategy review
The user has added three canonical sources to `references/` this iteration:
- **Mumford, *Abelian Varieties* (1970)** — the canonical source for the theorem of the
  cube + rigidity lemma (Milne's notes, already in tree, cite Mumford as canonical).
- **Hartshorne, *Algebraic Geometry*** — genus-0 curve with a rational point ≅ ℙ¹;
  `Ω_{ℙ¹} ≅ O(−2)`, `H⁰(ℙ¹, Ω) = 0`.
- **FGA Explained** — collected Kleiman (Picard) + Nitsure (Quot/Hilbert), backs Route A.

## What I want challenged (be a fresh, skeptical mathematician)
1. **Is route (c) the right next build?** STRATEGY commits the genus-0 arm to a
   characteristic-free AV-rigidity stack (theorem of the cube → Rigidity → Thm 3.2 →
   Prop 3.10), estimated ~1500–3500 LOC of abelian-variety theory that is ABSENT from
   Mathlib. The theorem of the cube is itself a deep formalization (seesaw, flat
   cohomology base change). Question hard: given Hartshorne is now in tree, is there a
   materially CHEAPER sufficient path for the genus-0 arm specifically — e.g. over `k̄`
   the curve is `ℙ¹`, and "every morphism `ℙ¹ → A` is constant" might be reachable from
   the concrete `H⁰(ℙ¹, Ω_{ℙ¹}) = H⁰(ℙ¹, O(−2)) = 0` (elementary, NOT general Serre
   duality) plus the converse `df=0 ⟹ constant` envelope the project already has closed
   (KDM/chart-algebra)? The iter-155 refutation of the `df=0` route was for a *general*
   genus-0 curve via chart-by-chart KDM; does it actually rule out the *concrete `ℙ¹`*
   computation? Or is the full theorem-of-the-cube stack genuinely the minimal route?
   I am NOT asking you to settle the math — I am asking whether STRATEGY has under-tested
   the cheapest-route question before committing to a 1500–3500 LOC AV-theory build.
2. **Risk concentration.** Both the genus-0 arm (route c, AV rigidity) and the
   positive-genus arm (Route A, FGA representability) now require building large amounts
   of absent-from-Mathlib geometry. Is the "genus-0 is the low-risk half" claim still
   credible once theorem-of-the-cube is costed honestly, or are BOTH arms multi-thousand-
   LOC research builds? Is the project's overall feasibility framing honest?
3. **Architecture.** The route-(c) rigidity declarations must live UPSTREAM of
   `Jacobian.lean` (an import cycle currently blocks `genusZeroWitness` from consuming
   `rigidity_over_kbar`, which sits downstream in `RigidityKbar.lean`). The plan is a new
   upstream Lean file for the AV rigidity stack. Any structural concern with that?
4. **Format / hygiene** of STRATEGY.md itself (per the canonical skeleton: phases table,
   routes, open questions, gaps; under ~250 lines).

## Output
Per your descriptor: SOUND / CHALLENGE / REJECT per claim, with the cheapest signal that
would change your verdict. Write to your `task_results/` report.
