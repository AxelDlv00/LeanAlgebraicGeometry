# Mathlib Analogist Directive

## Slug
cotangent-vanishing-pile-iter126

## Design question

What is current Mathlib's coverage of the **shared cotangent-vanishing
pile** that gates both M2.a body closure and the M2.d-alt genus-0
identification alternative in this project? Specifically, for each of
the four pieces below, what does Mathlib already have, what's missing,
and what is the per-piece project-internal LOC build estimate?

The four pieces:

**(i) Abelian-variety cotangent triviality.** The lemma "the relative
cotangent sheaf $\Omega_{A/k}$ of a smooth proper geometrically
irreducible group scheme $A$ over a field $k$ is free of rank
$\dim_k A$, with a global frame coming from left-invariant
differentials on the Lie algebra at the identity". Candidate Lean
target: `AlgebraicGeometry.AbelianVariety.cotangent_trivial` or
`AlgebraicGeometry.GroupScheme.Omega_trivial` (final naming TBD).

**(ii) Scheme-level $\mathrm{d}f = 0 \Rightarrow f$ factors through
$\Spec k$.** The companion algebraic fact: if a morphism $f \colon X
\to Y$ between smooth proper $k$-schemes has zero differential map
$f^* \Omega_{Y/k} \to \Omega_{X/k}$ at every point (e.g. because
$\Omega_{Y/k}$ is trivial and $H^0(X, \Omega_{X/k}) = 0$), then $f$
factors through the constant morphism. In characteristic $0$ this is
standard; in characteristic $p > 0$ it requires Frobenius handling
(see piece iii). Candidate Lean target: `AlgebraicGeometry.Morphism.isConst_of_diff_zero`
or `Scheme.factors_through_terminal_of_diff_zero` (final naming TBD).

**(iii) Characteristic-$p$ handling.** Three options on the table; the
analogist should choose which is most cost-effective given current
Mathlib coverage:

- *Frobenius iteration*: replace $f$ with $f \circ F^n$ for the $n$-th
  Frobenius and arrange so the iterated map has zero differential;
  descent of the conclusion uses smoothness of $Y$.
- *Mumford's argument* (Mumford, *Abelian Varieties*, Chapter~II~§4):
  exploits that abelian varieties contain no rational curves in
  characteristic $p$, via a direct sub-scheme argument.
- *Lifting to characteristic $0$*: lift $A$ via Witt vectors, run the
  differential argument over the lifted base, then descend.

**(iv) Serre duality on a smooth proper curve.** The Serre-duality
pairing $H^0(C, \mathcal F) \otimes H^1(C, \mathcal F^{\vee} \otimes
\omega_C) \to H^1(C, \omega_C) \cong k$ for a coherent sheaf $\mathcal
F$ on a smooth proper curve $C$ over $k$. **Used only by M2.d-alt, not
by M2.a's C.2.d** — but in scope for the shared-pile scoping. Project's
existing `analogies/serre-duality.md` file may already partially
address this; please consult and update if needed.

## Project artifact(s) under question

- `blueprint/src/chapters/RigidityKbar.tex:67-95` (the new iter-126
  chapter) — § "The shared cotangent-vanishing Mathlib pile" decomposes
  the pile into the four pieces above with per-piece estimated build
  cost 200–400 LOC each (total 800–1500 LOC).
- `blueprint/src/chapters/Jacobian.tex:332-348` (§ C.2.d "Key classical
  input") — presents the two-proof options for the keystone "proper
  rational curves on an abelian variety are constant" (dual abelian
  variety route via $\Pic^0(\mathbb P^1) = 0$; cotangent bundle route
  via triviality of $\Omega_{A/k}$).
- `analogies/serre-duality.md` — existing project analogy on Serre
  duality (read this first for piece iv).
- `analogies/c1-route.md` — existing project analogy on the curve-side
  cohomology infrastructure.

## Why now

Per the iter-126 user hint ("do the work, no axioms; ~6500–9000 LOC may
not be that much for an AI"), the iter-130 schedule for this analogist
consult is pulled forward to iter-126. Earlier scoping = earlier build
directive = ~4 iters earlier M2 closure on the honest estimate
(iter-162+ → iter-151+).

The scoping is the critical input for the iter-129+ shared-pile build
lanes: each piece will get its own blueprint chapter + Lean declaration
scaffold, with iter-by-iter prover lanes filling the bodies. The
analogist's output picks the build order (e.g. piece (i) before piece
(ii) because (ii) consumes (i); piece (iii) parallel to (ii) per
characteristic; piece (iv) standalone for M2.d-alt).

## Hints

- Mathlib snapshot in use: `b80f227` (matches the M3 route-pick audit
  baseline).
- **Piece (i) hints**:
  - Search `GroupObj`, `AbelianVariety`, `Algebra.LieAlgebra`,
    `KaehlerDifferential` ⨯ `GroupObj`.
  - Mathlib's `Mathlib.AlgebraicGeometry.GroupScheme` does NOT exist
    (verified iter-124 spot-check); the `CategoryTheory.GrpObj` is a
    bundled categorical structure, not the abelian-variety form.
- **Piece (ii) hints**:
  - Search `Morphism` ⨯ `Constant` ⨯ `Differential`,
    `LinearMap.eq_zero_of_diff_zero`,
    `Algebra.Derivation.isZeroOfDeriv`.
  - The algebraic side (ring-level df=0 for an integral domain in char 0)
    might be in `Mathlib.RingTheory.Derivation`.
- **Piece (iii) hints**:
  - Mathlib has Frobenius in `Mathlib.FieldTheory.Frobenius` and
    `Mathlib.RingTheory.WittVector.Frobenius`. Search for
    `Frobenius.preserves_smooth` or `Frobenius.iterate_diff_zero`.
  - For Witt vector lifting: `Mathlib.RingTheory.WittVector.Basic`.
- **Piece (iv) hints**:
  - Existing analogy file: `analogies/serre-duality.md`. Read first.
  - Mathlib search: `Curve.SerreDuality`,
    `AlgebraicGeometry.SerreDuality.smoothProper`,
    `CategoryTheory.Coherent.duality`.

## Severity expectation

**high-stakes** — this design WILL be load-bearing. The build directive
informs 8–12 iter / 800–1500 LOC of project work. Be strict on idiom
adherence (per-piece): if Mathlib has a partial idiom, the project must
align with it rather than building parallel; if Mathlib lacks an idiom
entirely, the project's build IS the upstream-PR-quality contribution.

The persistent file `analogies/cotangent-vanishing-pile.md` will be
re-read by every iter-129+ build lane, so be thorough and precise on
per-piece Mathlib citations.
