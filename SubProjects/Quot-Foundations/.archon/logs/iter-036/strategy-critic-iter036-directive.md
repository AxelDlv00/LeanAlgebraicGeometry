# Strategy Critic Directive

## Slug
iter036

## Project goal
Formalize the **Čech-independent leg** of the parent `thm:fga_pic_representability` cone (Kleiman FGA,
"The Picard scheme", §4): (FBC) the i=0 flat base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism
(`lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`); (GF) `thm:generic_flatness`
with algebraic core `thm:generic_flatness_algebraic`; (QUOT) `def:hilbert_polynomial`, `def:quot_functor`,
`def:grassmannian_scheme`, `thm:grassmannian_representable`. End-state: zero project `sorry` in the closure,
zero project axioms, kernel-only axioms. Advisory-frozen signatures: `genericFlatness`,
`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`, `QuotFunctor` (bodies free).

## Strategy under review
Read the current `STRATEGY.md` from disk (`/home/archon/proj/Quot-Foundations/STRATEGY.md`) — it was just
updated this iter. Do NOT read any `iter/iter-NNN/` sidecar, `task_*.md`, or prover/review report.

## References index
Read `references/summary.md` from disk for the source index. Key entries: `nitsure-hilbert-quot`
(primary; §1 Hilbert poly + Properness, §4 generic flatness, §5 Grassmannian/Quot), `stacks-coherent`
(tag 02KH flat base change H⁰), `stacks-schemes` (tag 01I9 widetilde-pullback / regroup), `stacks-properties`
(tag lemma-invert-f-sections = Hartshorne II.5.3, the gap1-D source), `hilbert-serre` (00K1 graded
Hilbert–Serre).

## Blueprint summary
- `Cohomology_FlatBaseChange.tex` — FBC: affine + flat base change of `H⁰`; mate/adjunction comparison,
  the regroup iso, the affine close (obligation 1 affine reduction + obligation 2 section identity).
- `Cohomology_RegroupHelper.tex` — `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (axiom-clean).
- `Picard_FlatteningStratification.tex` — GF: generic flatness, algebraic core (Nitsure §4 dévissage, done).
- `Picard_GrassmannianCells.tex` — GR: big-cell charts/cocycle, glued scheme, separatedness (done),
  properness via valuative criterion (existence E1–E4 in progress).
- `Picard_QuotScheme.tex` — QUOT: Hilbert poly, Quot/Grassmannian functor defs, gap1 (QCoh≃Mod affine
  descent) decomposed into C→P1→D→assembly; graded Hilbert–Serre.
- `Picard_RelativeSpec.tex` — relative Spec representability (downstream, gated).

## Focus for this audit
The FBC route was **pivoted this iter**: the conjugate-side `leftAdjointCompIso`/`conjugateEquiv.injective`
discharge of the `_legs`/`gstar_transpose` mate coherence is EXHAUSTED (5-iter stall) and ABANDONED; the
new active route is **affine-local explicit-inverse + element-`ext`** on obligation 2 (the section-level
identity). Audit specifically:
1. Is the pivot **rotation churn** (same hardest prerequisite one layer deeper) or a genuine change? The
   conjugate route's hardest prerequisite was the section-composite→`conjugateEquiv`-component reframing (a
   coherence proved under the `X.Modules` instance diamond). The explicit-inverse route's hardest
   prerequisite is the element-chase of the two round-trips of `pushforwardBaseChangeMap`'s inverse
   (`regroupEquiv`) WITHOUT crossing the diamond. Are these the same gap?
2. The open sub-question recorded in STRATEGY Q2: the element-`ext` chase must unfold
   `pushforwardBaseChangeMap.app U` to a concrete `ModuleCat` map without re-crossing the diamond. Is this
   a real risk that makes the pivot another dead end? If so, name a concrete alternative.
3. Obligation 1 (affine reduction @2303, restriction-compatibility, Mathlib-absent) is acknowledged as a
   SEPARATE owed build independent of the route choice. Is treating it as separate sound, or does the goal
   require it folded into the route now?
Also audit the other routes (GF, QUOT gap1 C→P1→D→Hfr→assembly, GR properness E1–E4) and the format.

## Prior critique status
- iter-035: FBC re-encoding treadmill + missing trip-wire — addressed (trip-wire fired, route pivoted).
- iter-035: GR bookkeeping (completed phases in active table) — addressed.
