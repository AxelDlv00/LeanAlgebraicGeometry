# Directive — strategy-critic, iter-198

## Mode
Read-only fresh-context critique.

## Project goal (one paragraph)

Formalize Christian Merten's *Algebraic Jacobian* challenge
(`references/challenge.lean.ref`): nine protected declarations
headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese /
Jacobian object uniform over the `k`-rational pointing of a smooth
proper geometrically irreducible curve `C / k`, **no** `C(k) ≠ ∅`
hypothesis. End-state: zero inline `sorry`, kernel-only axioms
(`propext`, `Classical.choice`, `Quot.sound`). Char-general: the
protected signatures take `[Field k]` only — NO `CharZero`.

## STRATEGY.md (verbatim)

(read the file directly at `.archon/STRATEGY.md`)

## Reference index (`references/summary.md`)

(read the file directly at `references/summary.md`)

## Blueprint summary (chapter title + one-line topic)

- `AbelJacobi.tex` — The Abel–Jacobi map (final wiring).
- `AbelianVarietyRigidity.tex` — Milne §I.3 rigidity; CONSOLIDATED
  chapter covering BareScheme + ChartIso + Points + GmScaling +
  RigidityLemma.
- `Albanese_AlbaneseUP.tex` — Albanese universal property of
  Pic⁰_{C/k} (divisor-map / Cartier route after Sym^g excised).
- `Albanese_AuslanderBuchsbaum.tex` — Auslander–Buchsbaum formula
  (Matsumura §19 / Stacks 090V).
- `Albanese_CodimOneExtension.tex` — codim-1 indeterminacy extension
  (A.4.a; Milne Thm 3.1 + Lemma 3.3).
- `Albanese_CoheightBridge.tex` — coheight ↔ Krull-dim bridge.
- `Albanese_Thm32RationalMapExtension.tex` — Milne Thm 3.2: rational
  maps into AV extend (A.4.c.1).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — cotangent at identity
  substrate (A.3.0).
- `Cohomology_MayerVietoris.tex` — MV long-exact sequence
  (substrate; closed).
- `Cohomology_SheafCompose.tex` — sheafification along forget
  (substrate; closed).
- `Cohomology_StructureSheafAb.tex` — sheaf-of-Ab structure
  (substrate; closed).
- `Cohomology_StructureSheafModuleK.tex` — sheaf-of-ModuleCat k
  structure (substrate; closed).
- `Differentials.tex` — relative cotangent presheaf (closed).
- `Genus.tex` — `genus C := dim_k H¹(C, O_C)` (closed).
- `Genus0BaseObjects_Cross01Substrate.tex` — Cross01 chart-bridge
  (substrate; closed).
- `Jacobian.tex` — Jacobian as abelian variety (final wiring).
- `Picard_FGAPicRepresentability.tex` — FGA representability of Pic
  scheme (A.2.c).
- `Picard_FlatteningStratification.tex` — Flattening (bypassed via
  Cartier route).
- `Picard_IdentityComponent.tex` — identity component of Pic
  (A.3.i; excised, file now substrate carrier).
- `Picard_LineBundlePullback.tex` — line bundle pullback (closed).
- `Picard_Pic0AbelianVariety.tex` — Pic⁰_{C/k} as AV (A.3.ii–vi).
- `Picard_QuotScheme.tex` — Quot scheme (bypassed via Cartier).
- `Picard_RelPicFunctor.tex` — relative Pic functor + ét-sheafify
  (A.1.c).
- `Picard_RelativeSpec.tex` — Relative Spec (A.1.a; closed).
- `RiemannRoch_H1Vanishing.tex` — RR.2.H¹ skyscraper vanishing
  (Route C; PAUSED).
- `RiemannRoch_OCofP.tex` — RR.3 O_C(P) sections (Route C; PAUSED).
- `RiemannRoch_OcOfD.tex` — RR.2_ O_C(D) sections (Route C; PAUSED).
- `RiemannRoch_RRFormula.tex` — RR.2 formula (Route C; PAUSED).
- `RiemannRoch_RationalCurveIso.tex` — RR.4 (Route C; PAUSED).
- `RiemannRoch_WeilDivisor.tex` — RR.1 Weil divisors (HYBRID: A.4.a
  general substrate + RR.1-specific lemmas; A.4.a sorries in-scope,
  RR.1 sorries PAUSED).
- `Rigidity.tex` — scheme-level rigidity (Mumford §4; closed).
- `RigidityKbar.tex` — k-base rigidity (Route C; PAUSED).

## Your task

Render a SOUND / CHALLENGE / REJECT verdict on the current
STRATEGY.md (just rewritten to reflect Route C PAUSE + Route A
bottom-up per USER 2026-05-28 standing directive). Specifically
evaluate:

1. Does the bottom-up Route A execution order respect actual
   mathematical dependencies? Are Priority 1 roots (A.4.a, A.4.b,
   A.1.a) genuinely ungated, or do they have hidden upstream needs?
2. Is the Cartier-route bypass of A.2.a + A.2.b mathematically
   coherent? The strategy claims A.2.c can take Cartier input
   directly without Quot/Grassmannian — does Kleiman §4 actually
   admit this rerouting, or does Pic-scheme existence in FGA
   genuinely chain through Quot?
3. Route C PAUSE: is freezing 84 sorries indefinitely a defensible
   project state, or is there a path to "complete" that requires
   re-engaging Route C? In particular, does the genus-0 arm of
   `nonempty_jacobianWitness` need Route C closure (RR.4 +
   genusZero_curve_iso_P1) to fire?
4. Pic⁰-via-degComp pivot — is the iter-197 analogist sanction
   (`STRUCTURAL_OK`) still defensible from a fresh reading?
5. Carrier-soundness probe — abort verdict due iter-198. What is the
   actual signal that determines abort, and is the timing right?
6. STRATEGY.md format — does it conform to the canonical skeleton
   (Goal / Phases / Routes / Open questions / Mathlib gaps)? Any
   accumulation, per-iter narrative, or stale rows from prior iters?

## Output

Write to `task_results/strategy-critic-route198.md`. Use the
descriptor's standard report shape (Verdict + per-section findings +
explicit CHALLENGE / REJECT items the planner must address).
