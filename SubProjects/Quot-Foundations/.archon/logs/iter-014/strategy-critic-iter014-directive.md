# Strategy-critic directive — iter-014 (Quot-Foundations)

Fresh-context review of the global strategy. You have NO iter history — challenge the
strategy as a fresh mathematician would. Focus especially on two live pressure points:
(1) the FBC-A route, which has spent many iters on the adjoint-mate/section-identity
machinery and is now down to three "seam" coherence lemmas with no Mathlib idiom — is the
section-level decomposition route sound and going to close, or is there a structurally
cheaper route? (2) the SNAP graded Hilbert–Serre rationality, whose power-series half is
done but whose residual is a Mathlib-absent graded-module-quotient/kernel/regrading API —
is building that API project-side the right call, or is there a route that avoids it?

## Project goal (one paragraph)
Close the seven `sorry`-bearing nodes of the Čech-independent leg of the parent project's
`thm:fga_pic_representability` cone (Kleiman, "The Picard scheme", FGA §4): flat base change
of the i=0 pushforward (FBC), generic flatness with its algebraic core (GF), and the Quot/
Grassmannian foundations — Hilbert polynomial, Quot functor, Grassmannian scheme, and its
representability (QUOT). End-state: zero project `sorry` in the closure, zero project axioms,
kernel-only axioms; names/labels match the parent's so finished work merges back.

## Current STRATEGY.md (verbatim)
<<<read the file directly: /home/archon/proj/Quot-Foundations/STRATEGY.md>>>

## Reference index (references/summary.md)
- nitsure-hilbert-quot.pdf/.tex — Nitsure, "Construction of Hilbert and Quot Schemes" (FGA
  Explained). PRIMARY source: §1 Hilbert polynomial (Snapper), §2 Quot functor, §4 Lemma on
  Generic Flatness (full induction — backs GF), §5 Grassmannian + Quot construction (backs QUOT-repr).
- stacks-coherent.tex — Stacks ch.30 Cohomology of Schemes, tag 02KH (flat base change of R^i f_*;
  part 2 = H^0-with-base-change). Backs FBC.
- stacks-schemes.tex — Stacks "Schemes", tag 01I9 (ψ* M̃ and ψ_* Ñ for affine ψ). Backs the FBC
  tilde dictionaries.
- stacks-constructions.tex — Stacks ch.27 Constructions, relative-spectrum tags. Backs RelativeSpec.
- hartshorne-algebraic-geometry.pdf — Hartshorne GTM 52: II.§5 qcoh, II.§7 Grassmannians/projective
  morphisms, III.§9 flat families & Hilbert polynomials. Companion for QUOT.
- hilbert-serre-algebra.tex — Stacks "Algebra" §Noetherian graded rings, tag 00K1 (graded
  Hilbert–Serre rationality, inductive proof via the degreewise SES). Backs SNAP
  `lem:gradedHilbertSerre_rational`.

## Blueprint chapter summary (titles + one-line topic)
- Cohomology_FlatBaseChange — flat base change of the i=0 pushforward of a qcoh sheaf (FBC; affine
  lemma direct-on-sections via tilde dictionaries + section-level mate identities + globalization).
- Cohomology_RegroupHelper — the regrouping iso `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (FBC helper, CLOSED).
- Picard_FlatteningStratification — generic flatness (GF): algebraic core via Nitsure §4 induction
  on variable count, Nagata change-of-variables machinery, the torsion-reindex + denominator-clearing.
- Picard_GrassmannianCells — the Grassmannian big-cell charts over ℤ, transition maps, cocycle
  condition (GR-cells, CLOSED) → glued scheme (forward).
- Picard_QuotScheme — Hilbert polynomial via graded Hilbert–Serre rationality (SNAP), Quot functor,
  Grassmannian scheme, representability; schematic-support / proper-support / local-freeness predicates.
- Picard_RelativeSpec — relative Spec construction (Stacks ch.27); proved as IsAffineHom/IsAffine,
  with acknowledged weakenings vs. the RepresentableBy form needed downstream.

Deliver: per-route SOUND / CHALLENGE / REJECT, with the cheapest structural alternative for any
route you challenge. Pay special attention to FBC-A and SNAP per the framing above.
