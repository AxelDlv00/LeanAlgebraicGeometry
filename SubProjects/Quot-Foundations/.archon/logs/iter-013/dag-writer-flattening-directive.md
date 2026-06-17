# Blueprint Writer Directive

## Slug
dag-writer-flattening

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Strategy context
This chapter blueprints the **generic-flatness** algebraic core (GF route): a Noetherian
domain `A`, a finite-type `A`-algebra `B`, a finite `B`-module `M` ⟹ ∃ `f≠0` with `M_f` free
over `A_f` (Nitsure §4). The polynomial-ring core `lem:gf_polynomial_core` runs the Nitsure §4
induction on the variable count `d`, using a **Nagata change of variables** that makes a chosen
polynomial monic in the last variable. The Lean file `FlatteningStratification.lean` carries a
cluster of small `private` helper lemmas in namespace `AlgebraicGeometry.GenericFreeness` that
implement this Nagata machinery and the monic-degree bookkeeping. They are currently proved in
Lean (`leanok`) but have **no blueprint entry**, so the Lean↔blueprint correspondence is broken
for them. Your job is to add a concise blueprint entry for each so the dependency graph is 1-to-1.

## Required content
Add one concise blueprint block (`\definition` / `\lemma` as appropriate) for **each** of the
following Lean declarations. Read `AlgebraicJacobian/Picard/FlatteningStratification.lean` to get
each one's exact signature and role; **the namespace is `AlgebraicGeometry.GenericFreeness`** so
the `\lean{}` target is e.g. `AlgebraicGeometry.GenericFreeness.T`.

These are **project-internal technical helpers** implementing the Nagata change-of-variables step;
they are Archon-original (no external verbatim quote required), but they realize the Nagata trick
described in Nitsure §4 — you MAY add a one-line `\textit{Source: Nitsure §4 (Nagata change of
variables).}` pointer on the `T`/`T1` definitions if it reads naturally (no `% SOURCE QUOTE:` needed
for these internal helpers).

- `AlgebraicGeometry.GenericFreeness.T` (definition) — the Nagata change-of-variables algebra
  endomorphism of the polynomial ring sending `X_i ↦ X_i + X_0^{c_i}` (read the def for the exact
  substitution); used to make a polynomial monic in the distinguished variable.
- `AlgebraicGeometry.GenericFreeness.T1` (definition) — the single-variable companion shift
  `X_0 ↦ X_0 + c` (read the def); its self-inverse property is `t1_comp_t1_neg`.
- `AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg` (lemma) — `T1 c ∘ T1 (-c) = id`, i.e. the
  shift is invertible with inverse the opposite shift.
- `AlgebraicGeometry.GenericFreeness.lt_up` (lemma) — a bookkeeping bound: if every exponent
  `v i < up` then every entry of the listed exponent vector is `< up`. One-line.
- `AlgebraicGeometry.GenericFreeness.sum_r_mul_ne` (lemma) — distinct exponent vectors `v ≠ w`
  (each entry `< up`) give distinct base-`up` weighted sums `∑ r·v_i`; injectivity of the
  radix encoding used to separate monomials. One-line.
- `AlgebraicGeometry.GenericFreeness.degreeOf_zero_t` (lemma) — the `X_0`-degree of `T(monomial
  v a)` for `a ≠ 0` equals the value given by the radix encoding.
- `AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne` (lemma) — distinct support monomials of
  `f` acquire distinct `X_0`-degrees after applying `T`; the key separation property making the
  top degree unique.
- `AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t` (lemma) — identifies the
  leading coefficient (in `X_0`, via `finSuccEquiv`) of `T(f)`.
- `AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq` (lemma, hyp `f ≠ 0`) — the leading
  coefficient of `T(f)` in the distinguished variable is the (nonzero) coefficient coming from
  the unique top monomial, so `T(f)` is, up to a unit, monic in that variable.
- `AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm` (theorem) — naturality/commutation of
  `finSuccEquiv` (the iso `MvPolynomial (Fin (n+1)) ≅ Polynomial (MvPolynomial (Fin n))`) with a
  ring map applied coefficientwise. A technical compatibility lemma.
- `AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ` (theorem) — commutation of
  `finSuccEquiv` with `rename Fin.succ` (variable reindexing). Technical compatibility lemma.

For each: a short mathematical statement in the project's notation, a `\label{}` (suggest
`lem:gf_*` / `def:gf_*` using the Lean basename, e.g. `def:gf_nagata_T`, `lem:gf_t1_self_inverse`),
the exact `\lean{}`, an accurate `\uses{}`, and a **one-to-two line** proof sketch — or
`\begin{proof}\leanok-free: Proved directly in Lean by explicit computation.\end{proof}` style note
(write `Proved directly in Lean.` — do NOT add `\leanok`) for the pure-computation glue lemmas.

**Wire the `\uses{}` both ways:** after reading the .lean, add `\uses{}` edges from each existing
blueprinted GF lemma whose Lean proof invokes these helpers (in particular `gf_nagata_monic_lastVar`
/ `gf_mvPolynomial_quotient_finite_monic` / `gf_torsion_reindex` — check which) so the new blocks
are not isolated. Run `leandag build --json` and confirm none of your new blocks is isolated and no
`\uses{}` is broken.

## Out of scope
- Do NOT modify the statements of the existing meaningful GF theorems/lemmas
  (`thm:generic_flatness_algebraic`, `lem:gf_polynomial_core`, `lem:gf_noether_clear_denominators`,
  `lem:gf_torsion_reindex`, `thm:generic_flatness`) beyond adding `\uses{}` edges to the new helpers.
- Do NOT add `\leanok` markers (the deterministic sync owns them).
- Do NOT touch any other chapter.

## References
- `references/nitsure-hilbert-quot.md` → §4 "Lemma on Generic Flatness" (Nagata change of variables)
  — for the `T`/`T1` definitions' source pointer only; these helpers are project-internal so a
  one-line `\textit{Source: ...}` pointer suffices, no verbatim `% SOURCE QUOTE:` block required.

## Expected outcome
The chapter gains 11 concise helper blocks (in namespace `AlgebraicGeometry.GenericFreeness`),
each with `\label`/`\lean`/`\uses` and a short proof or "Proved directly in Lean." note, wired into
the existing GF Nagata lemmas so `leandag` reports zero unmatched-lean and zero isolated nodes for
this chapter's helper cluster.
