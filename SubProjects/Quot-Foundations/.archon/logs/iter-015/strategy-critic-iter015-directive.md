# Strategy-critic — iter-015

Fresh-eyes critique of the project strategy. You have NO iter-by-iter history; judge the strategy as
a mathematician seeing it for the first time. Your prior verdict (iter-014) was CHALLENGE on FBC and
QUOT (GF SOUND); the planner recorded those as addressed in STRATEGY.md. **Re-verify whether the
still-relevant aspects of those challenges are genuinely resolved by the current STRATEGY.md text**,
and raise any new concern.

## Project goal (one paragraph)

Formalize, in Lean 4 + Mathlib, the **Čech-cohomology-independent leg** of the FGA Picard-scheme
representability cone (Kleiman, "The Picard scheme", FGA): (FBC) flat base change of the i=0
pushforward of a quasi-coherent sheaf is an isomorphism; (GF) generic flatness, algebraic core +
geometric form; (QUOT) the Hilbert-polynomial encoding, Quot functor, Grassmannian scheme, and its
representability. End-state: zero project `sorry` in the 29-node closure, zero project axioms,
kernel-only axioms; names/labels match the parent cone so the work merges back.

## STRATEGY.md (verbatim)

(Read the current file at `STRATEGY.md` in the project root — it is the authoritative copy. Critique
it as written.)

## Reference index (what backs which target)

- Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590): §1
  Hilbert polynomial, §2 Quot functor, §4 Lemma on Generic Flatness (induction proof — backs GF), §5
  Grassmannian + Quot construction.
- Stacks 02KH (flat base change of Rⁱf_*, part 2 H⁰) — backs FBC.
- Stacks 01I9 (`ψ* M̃`, `ψ_* Ñ` for affine ψ) — backs the tilde dictionaries used in FBC.
- Stacks 00K1 (graded Hilbert–Serre rationality, induction via the degree-1-multiplication SES) —
  backs the QUOT `lem:gradedHilbertSerre_rational`.
- Hartshorne (GTM 52): background for Quot/Grassmannian (II.§5, II.§7, III.§9).

## Blueprint chapters (title + one-line topic)

- Cohomology_FlatBaseChange.tex — flat base change for the i=0 pushforward (the FBC seams).
- Cohomology_RegroupHelper.tex — the geometry-free tensor-regroup iso `(A⊗_R R')⊗_A M ≅ R'⊗_R M`.
- Picard_FlatteningStratification.tex — generic flatness / flattening (the GF dévissage engine).
- Picard_GrassmannianCells.tex — Grassmannian affine charts + cocycle gluing (GR-cells, DONE).
- Picard_QuotScheme.tex — Hilbert polynomial, Quot functor, graded Hilbert–Serre rationality
  (power-series engine + graded-module API), Quot predicates.
- Picard_RelativeSpec.tex — relative Spec (feeds QUOT-repr).

## What to check specifically

1. **FBC route** (your prior CHALLENGE): the route is the canonical-map seam decomposition (Seam 1
   closed). The merge-back-necessity question is now framed as a contingency. Is that framing sound,
   or should the ∃-iso escape be tested NOW rather than deferred?
2. **QUOT route** (your prior CHALLENGE): the Hilbert encoding = graded Hilbert function (not
   cohomological χ), with the rationality step as a project lemma over the existing Mathlib graded
   scaffold. Is the decomposition (power-series engine DONE + graded-module API G1–G5/D5) the right
   shape? Is `def:sectionGradedRing` (the S1 bridge) adequately scheduled? Is the open
   `[Module.Finite κ (𝒜 1)]` hypothesis question a real strategic risk?
3. Any phase whose `Iters left` / LOC estimate looks materially wrong, any missing prerequisite, any
   hallucinated Mathlib dependency, any case-split that the references do not require.
