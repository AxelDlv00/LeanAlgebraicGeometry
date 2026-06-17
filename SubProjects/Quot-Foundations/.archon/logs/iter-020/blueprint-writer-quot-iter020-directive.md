# blueprint-writer directive — Picard_QuotScheme.tex (iter-020)

Chapter: `blueprint/src/chapters/Picard_QuotScheme.tex`
(covers `AlgebraicJacobian/Picard/QuotScheme.lean`).

Two jobs this iter: **(A)** fix the base-case proof of the SNAP-S2 keystone induction so it gives the
real degreewise-independence argument and steers the prover to the WORKING route (route b), not the
dead-end route (a); **(B)** clear the 17 coverage-debt helper nodes (Lean decls with no blueprint
block). Do NOT touch the protected stubs, the Mathlib anchors, or any `\leanok`/`\mathlibok` marker
(those are managed elsewhere). Do NOT add `\leanok`.

---

## Job A — base-case argument for `lem:graded_subquotient_isRatHilb` (route b)

### Context
The keystone `gradedModule_hilbertSeries_rational` is fully assembled in Lean modulo ONE residual
`sorry`: the base case `r = 0` of `lem:graded_subquotient_isRatHilb`. In Lean this base case is the
helper `AlgebraicGeometry.GradedModule.subquotient_base_eventuallyZero`, whose only hole is
`iSupIndep (fun n => LinearMap.range (ψ n))` — the independence of the degreewise image maps.

The current blueprint base-case prose (in the `proof` of `lem:graded_subquotient_isRatHilb`,
"Base case r = 0") only asserts "M is finite-dimensional over κ, hence N∩ℳ_n = 0 for n ≫ 0". It does
**not** justify *why* only finitely many degrees are nonzero — that is exactly the independence
argument the formalization needs, and the blueprint must supply it.

### What the base case actually requires (write this rigorously)
Let `(N, N')` be a length-0 subquotient datum, so the finiteness witness makes the ambient quotient
`Q₀ := M / N'`-relevant piece a **finite-dimensional κ-vector space** (via
`lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite`: `MvPolynomial(∅,κ) ≅ κ`). For each
degree `n`, the inclusion of the homogeneous piece `N ∩ ℳ_n` followed by the projection to the
subquotient gives a κ-linear map `ψ_n : N ∩ ℳ_n → Q₀`. Then:

1. **Independence (the residual leaf):** the family `(LinearMap.range (ψ n))_{n}` is `iSupIndep` in
   `Q₀`. The reason is the ambient direct-sum grading of `M`: an element of `⨆_{j ≠ n} range(ψ j)`
   is a sum of homogeneous classes of degrees `≠ n`, and homogeneity of `N'` (the datum's `hN'`)
   means the degree-`n` homogeneous component of such a sum is `0` in `Q₀`, while a nonzero class in
   `range(ψ n)` has nonzero degree-`n` component. Independence follows.

2. **Finiteness of support:** since `Q₀` is finite-dimensional and the ranges are independent,
   `Submodule.finite_ne_bot_of_iSupIndep` gives that only finitely many `range(ψ n)` are nonzero.

3. **Eventual vanishing → rationality:** beyond the (bddAbove) threshold, `range(ψ n) = ⊥`, so
   `N ∩ ℳ_n ≤ N'` and `hilb(n) = 0`. An eventually-zero function is `IsRatHilb` of order `0`
   (`lem:ratHilb_ofEventuallyZero`).

### Route discipline — record BOTH the working route and the dead end
The prover must use **route (b)** for step 1 (independence). State it in the proof prose AND in a
`% NOTE:` so it is unmissable:

- **Route (b) — USE THIS.** Prove `iSupIndep` by destructuring membership in `⨆_{j ≠ n} range(ψ j)`
  via `Submodule.mem_iSup_iff_exists_dfinsupp` and reading off the **degree-`n` homogeneous
  component directly inside `Q₀`'s fixed κ-module structure** — no outgoing linear map is built, so
  no scalar ring is introduced.
- **Route (a) — DEAD END, do not retry.** Building a κ-linear detector
  `Φ : Q₀ →ₗ[κ] M / N'`, `[m] ↦ [π_n m]`, via `Submodule.liftQ` fails: `liftQ` over the
  `MvPolynomial(Fin 0,κ)`-quotient produces an `MvPolynomial(Fin 0,κ)`-(semi)linear map, but the
  target is only a κ-module — a scalar-ring clash. (Confirmed dead end iter-019.)

### Deliverable for Job A
- Give `subquotient_base_eventuallyZero` its **own** `\begin{lemma} … \end{lemma}` block with
  `\label{lem:graded_subquotient_base_eventuallyZero}`,
  `\lean{AlgebraicGeometry.GradedModule.subquotient_base_eventuallyZero}`, accurate `\uses{}` (it
  uses `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite`,
  `lem:graded_homogeneousSubmodule_iSupIndep` if relevant, `lem:ratHilb_ofEventuallyZero`, and the
  Mathlib `Submodule.finite_ne_bot_of_iSupIndep` — add a `\mathlibok` Mathlib anchor block for the
  latter if one does not already exist), and an informal proof carrying steps 1–3 above + the
  route-(b) NOTE and the route-(a) dead-end NOTE.
- Wire `lem:graded_subquotient_isRatHilb`'s base case to cite the new lemma
  (`\cref{lem:graded_subquotient_base_eventuallyZero}`) and add it to that lemma's `\uses{}`.

---

## Job B — clear the coverage-debt helper nodes (16 blocks)

Each of the following landed, axiom-clean Lean decls has NO blueprint block (leandag `unmatched`).
Give each a block: `\label`, `\lean{<exact name>}`, accurate `\uses{}` (statement-level), and at
least a one-line informal proof. These are project-bespoke infrastructure (no external source needed
— omit `% SOURCE`). Group them under a new subsubsection (e.g. "Finiteness-transfer infrastructure"
and "Subquotient constructors") near the existing `lem:graded_subquotient_finite_transfer` /
`lem:graded_subquotient_ker_coker` blocks they support. Consult the prover's dependency notes (the
"Needs blueprint entry" section in `.archon/task_results/AlgebraicJacobian_Picard_QuotScheme.lean.md`,
already archived) for each helper's actual `\uses`.

Namespace `AlgebraicGeometry.GradedModule` for all:

1. `lastVarAlgHom` + siblings `lastVarAlgHom_X_castSucc`, `lastVarAlgHom_X_last`, `lastVarAlgHom_C`,
   `lastVarAlgHom_rename_castSucc`, `lastVarAlgHom_surjective`, and the instance
   `lastVarAlgHom_ringHomSurjective` — the surjection `MvPolynomial (Fin (r+1)) κ ↠
   MvPolynomial (Fin r) κ` (`X last ↦ 0`, `X (castSucc i) ↦ X i`). You may give the family ONE block
   for `lastVarAlgHom` with the simp-lemma siblings + surjectivity listed in its proof prose and
   individually `\lean{}`-pinned sub-entries, OR one block per decl — your judgement, but every name
   above must carry a resolving `\lean{}` pin. Uses: `MvPolynomial.aeval`, `Fin.lastCases`,
   `MvPolynomial.rename`.
2. `polyEndHom_mem_of_stable` — a `t`-stable submodule is closed under `polyEndHom p`. Uses:
   `MvPolynomial.induction_on`, the existing `polyEndHom_C`/`polyEndHom_X` blocks.
3. `polyEndHom_lastVar_sub_mem` — the mod-`P'` semilinearity heart of the finiteness transfer. Uses:
   `MvPolynomial.induction_on`, `Fin.eq_castSucc_or_eq_last`, `lem` for `polyEndHom_mem_of_stable`.
4. `polyQuot_finite_of_le_denominator`, `polyQuot_finite_of_le_numerator` — over-`S` finiteness of
   the cokernel/kernel feeding `SubquotientDatum.coker`/`.ker`. Uses: `Module.Finite.of_surjective` /
   `.of_injective`, `MvPolynomial.isNoetherianRing_fin`, `isNoetherian_of_isNoetherianRing_of_finite`.
5. `ker_stable_full`, `coker_stable_full` — kernel/cokernel pair stable under the full degree-1
   family (the over-`S` finiteness inputs). Uses: the existing `comap_map_le_of_commute` /
   `map_map_le_of_commute` blocks.
6. `SubquotientDatum.ker`, `SubquotientDatum.coker` — the two length-`(r+1) → r` constructors. These
   are referenced narratively by `lem:graded_subquotient_ker_coker`; give each its OWN `\lean{}`
   block (they are constructors/defs, not lemmas — use `\begin{definition}`). Uses: the
   `ker_isHomogeneous`/`coker_isHomogeneous`, `ker_le`/`coker_le`, `comap_map_le_of_commute`/
   `map_map_le_of_commute` blocks, plus `lem:graded_subquotient_finite_transfer` and the
   `polyQuot_finite_of_le_*` blocks for the `hfin` field.

For the existing `lem:graded_subquotient_finite_transfer` block: the landed Lean decl
`subquotient_finite_transfer` is the **abstract single-pair σ-transfer** along `lastVarAlgHom`, not
the K,C-specific phrasing the current prose may suggest. Adjust the prose to match the abstract
statement and add `\uses{}` edges to `lastVarAlgHom_surjective`, `polyEndHom_lastVar_sub_mem`, and
the Mathlib `Module.Finite.of_surjective` / `Submodule.liftQ` anchors.

`finrank_comap_subtype` is **intentionally `private`** in Lean — do NOT give it a public `\lean{}`
pin (it will not resolve). Either omit it or add a prose-only `% NOTE:` recording it as a private
implementation detail. (It is the 18th unmatched node and is expected to remain unmatched.)

---

## Out of scope
- Do NOT modify the Grassmannian/Quot/Hilbert-polynomial skeleton blocks, the `sectionGradedRing`
  blocked-on-Mathlib blocks, or the `isRatHilb` private-toolkit blocks (those are separate hygiene).
- Do NOT add `\leanok`. Do NOT touch the protected-stub blocks.
- Keep prose math-only (no Lean tactic syntax in the informal proofs).

You have `references/**` in your write domain in case a base-case citation needs the Stacks 00K1
source — but the base-case independence argument is project-bespoke (the Stacks proof asserts
"$M_n = 0$ for $n \gg 0$" without the κ-vector-space independence detail), so a `% SOURCE QUOTE` on
the existing Tag-00K1 lines is enough; no new retrieval is expected.
