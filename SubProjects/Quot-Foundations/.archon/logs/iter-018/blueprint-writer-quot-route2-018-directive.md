# Blueprint Writer Directive

## Slug
quot-route2-018

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Strategy context
The SNAP-S2 graded Hilbert–Serre rationality step uses **Route 2 — the ambient subquotient induction** (Stacks 00K1). Instead of forming graded quotient rings/modules (a Mathlib `isDefEq`/`whnf` dead-end), the induction runs over pairs of homogeneous submodules `N' ≤ N` of a single FIXED ambient graded κ-module `M` with `r` commuting degree-+1 endomorphisms; the Hilbert function is the ambient difference `n ↦ dim_κ(N ⊓ ℳn) − dim_κ(N' ⊓ ℳn)`. The class is closed under ker/coker of a degree-1 endo, so no derived-carrier graded object is ever formed.

The last prover pass landed the keystone D6 `subquotient_degreewise_diff` and a complete **ambient homogeneity calculus** (11 new Lean helpers), all axiom-clean, but ELEVEN of these have NO blueprint entry (coverage debt — isolated `lean_aux` nodes). It then BLOCKED on the **finiteness encoding** for the `P(r)` induction and scouted the exact tool path. Your job is TWO things:
(A) author the 11 missing homogeneity-calculus blocks (project-bespoke, no external source), and
(B) enrich the existing `lem:graded_subquotient_finite_transfer` and `lem:graded_subquotient_isRatHilb` blocks with the scouted finiteness-encoding mechanism so the next prover (mathlib-build) has a concrete recipe.

Read the existing Route-2 subsection first (subsection "The ambient subquotient induction for the Stacks~00K1 step", around line 758 onward), including the existing blocks `def:graded_subquotientHilb`, `lem:graded_subquotient_ker_coker`, `lem:graded_subquotient_degreewise_diff`, `lem:graded_subquotient_finite_transfer`, `lem:graded_subquotient_isRatHilb`, and the Mathlib anchors (`lem:fg_restrictScalars_of_surjective_mathlib`, etc.).

## Required content

### (A) Ambient homogeneity-calculus blocks (11 new, project-bespoke — NO `% SOURCE`)

Add a new `\subsubsection*{Ambient homogeneity calculus}` under the Route-2 subsection (before `lem:graded_subquotient_ker_coker`, since these feed its homogeneity content). Each block: concise informal statement, `\label{}`, `\lean{}` (exact name, namespace `AlgebraicGeometry.GradedModule`), accurate `\uses{}`, one-line informal proof. The setting throughout: `M = ⊕ₙ ℳn` an internally graded κ-module, `x : M →ₗ[κ] M` a degree-raising endomorphism (`RaisesDegree`).

1. `def:graded_raisesDegree` — `\lean{AlgebraicGeometry.GradedModule.RaisesDegree}`. Definition: a κ-endomorphism `x` of `M` *raises degree* when `(ℳn).map x ≤ ℳ(n+1)` for all `n` (the grading-ring-free form of "multiplication by a degree-1 element"). This abstracts the `r` commuting degree-+1 generators.
2. `lem:graded_raisesDegree_mem` — `\lean{AlgebraicGeometry.GradedModule.RaisesDegree.mem}`. Membership form: if `x` raises degree and `m ∈ ℳn` then `x m ∈ ℳ(n+1)`. `\uses{def:graded_raisesDegree}`.
3. `lem:graded_decompose_raisesDegree` — `\lean{AlgebraicGeometry.GradedModule.decompose_raisesDegree}`. The load-bearing degree-shift commutation: the degree-`(i+1)` homogeneous component of `x m` equals `x` applied to the degree-`i` component of `m` (`decompose ℳ (x m) (i+1) = x (decompose ℳ m i)` at the carrier level). `\uses{def:graded_raisesDegree, lem:graded_raisesDegree_mem}`.
4. `lem:graded_decompose_raisesDegree_zero` — `\lean{AlgebraicGeometry.GradedModule.decompose_raisesDegree_zero}`. The degree-0 component of `x m` is 0 (degree-raising kills the bottom). `\uses{def:graded_raisesDegree}`.
5. `lem:graded_comap_isHomogeneous` — `\lean{AlgebraicGeometry.GradedModule.comap_isHomogeneous}`. The preimage `N.comap x` of a homogeneous submodule `N` under a degree-raising endo is homogeneous. `\uses{lem:submodule_isHomogeneous_mathlib, lem:graded_decompose_raisesDegree, lem:graded_decompose_raisesDegree_zero}`.
6. `lem:graded_map_isHomogeneous` — `\lean{AlgebraicGeometry.GradedModule.map_isHomogeneous}`. The image `N.map x` of a homogeneous submodule is homogeneous. `\uses{lem:submodule_isHomogeneous_mathlib, lem:graded_decompose_raisesDegree}`.
6b. `lem:graded_inf_isHomogeneous` — `\lean{AlgebraicGeometry.GradedModule.inf_isHomogeneous}`. The intersection of two homogeneous submodules is homogeneous (lattice closure; Mathlib lacks it). `\uses{lem:submodule_isHomogeneous_mathlib}`.
6c. `lem:graded_sup_isHomogeneous` — `\lean{AlgebraicGeometry.GradedModule.sup_isHomogeneous}`. The sum (join) of two homogeneous submodules is homogeneous. `\uses{lem:submodule_isHomogeneous_mathlib}`.
7. `lem:graded_map_inf_degree_eq` — `\lean{AlgebraicGeometry.GradedModule.map_inf_degree_eq}`. The ambient image identity `N.map x ⊓ ℳ(n+1) = (N ⊓ ℳn).map x` (the degree-`(n+1)` part of `xN` is `x` of the degree-`n` part of `N`). `\uses{lem:graded_decompose_raisesDegree, lem:graded_map_isHomogeneous}`.
8. `lem:graded_sup_inf_degree_eq` — `\lean{AlgebraicGeometry.GradedModule.sup_inf_degree_eq}`. The ambient distributive law for homogeneous `P, Q`: `(P ⊔ Q) ⊓ ℳk = (P ⊓ ℳk) ⊔ (Q ⊓ ℳk)`. `\uses{lem:graded_inf_isHomogeneous, lem:graded_sup_isHomogeneous, lem:submodule_isHomogeneous_mathlib}`.

(The private Lean helper `finrank_comap_subtype` is `private` and may be left without a block, OR given a one-line entry — your discretion; if you give it one, `\lean{}` will not resolve because it is private, so PREFER to omit it and instead mention in "Notes for Plan Agent" that it is private and intentionally unblueprinted.)

Wire these into the existing `lem:graded_subquotient_ker_coker` (its homogeneity content is exactly `comap`/`map`/`inf`/`sup`-isHomogeneous) and `lem:graded_subquotient_degreewise_diff` (uses `map_inf_degree_eq` + `sup_inf_degree_eq`) — add the corresponding `\uses{}` to those two blocks' proofs.

### (B) Enrich the finiteness-encoding recipe

The next prover must build `Module.Finite (MvPolynomial (Fin r) κ) M` from the `r` commuting degree-1 endomorphisms. Enrich the EXISTING blocks (do not change their statements/`\lean{}`; expand the proof prose / add a remark) with the scouted construction:

- In `lem:graded_subquotient_finite_transfer` (and/or a short remark near `lem:graded_subquotient_isRatHilb`): describe that the `MvPolynomial (Fin r) κ`-module structure on `M` is obtained by:
  (i) the `r` commuting endos generate a **commutative** κ-subalgebra `A := Algebra.adjoin κ {x₀,…,x_{r-1}} ⊆ End_κ(M)` (commutativity from pairwise-commuting generators — Mathlib's `Algebra.adjoinCommRingOfComm` gives `A` a `CommRing` structure);
  (ii) `aeval` of the generators is then a legal κ-algebra hom `MvPolynomial (Fin r) κ →ₐ[κ] A` (legal precisely because the target `A` is commutative — `aeval` refuses the noncommutative `End_κ(M)` directly);
  (iii) composing with `A ⊆ End_κ(M)` and `Module.compHom` puts a `MvPolynomial (Fin r) κ`-module structure on `M`, compatible with the κ-action and with `Xᵢ • m = xᵢ m`;
  (iv) the inductive transfer down one generator uses the surjection `κ[t₀,…,t_{r-1}] ↠ κ[t₀,…,t_{r-2}]` (`Xᵢ` for `i<r-1` fixed, `X_{r-1} ↦ 0`), and `lem:fg_restrictScalars_of_surjective_mathlib`: because the top endo `x_{r-1}` annihilates both subquotients `K` and `C` (from `lem:graded_subquotient_ker_coker`), their `κ[t₀..t_{r-1}]`-action factors through this surjection, yielding the length-`(r-1)` finiteness witness.
  Critically note (the prover ruled this out): the smaller ring MUST be the free polynomial ring `κ[t₀..t_{r-2}]`, NOT `Algebra.adjoin κ {x₀..x_{r-2}}` — relations among the endos in `End_κ(M)` would break the `restrictScalars_of_surjective` transfer.
- Add a Mathlib dependency anchor for `Algebra.adjoinCommRingOfComm` if not already present: `\lean{Algebra.adjoinCommRingOfComm}`, `\mathlibok`, stating "the subalgebra generated by a set of pairwise-commuting elements of a (possibly noncommutative) algebra carries a CommRing structure." Only mark `\mathlibok` if you can confirm the declaration name is faithful — if unsure, write the block WITHOUT `\mathlibok` and flag it in Notes for Plan Agent for the reviewer to verify against Lean.
- Note that the base case (`r = 0`) of the induction is: `M` finite over `κ[] = κ` ⟹ `M` finite-dimensional ⟹ `ℳn = ⊥` for `n ≫ 0` ⟹ the subquotient Hilbert function is eventually 0 ⟹ `IsRatHilb` via `IsRatHilb.ofEventuallyZero` (confirm this `\lean{}` name exists in the chapter's `IsRatHilb` toolkit; if the eventually-zero constructor has a different name, describe it by its mathematical role and flag in Notes).
- Mention that the subquotient datum (the bundle of `N' ≤ N` homogeneous + the `r` commuting `RaisesDegree` endos preserving `N, N'` + the `MvPolynomial (Fin r) κ`-module structure + scalar-tower + `Module.Finite`) is best packaged as a `structure` so `lem:graded_subquotient_ker_coker` can hand `K` and `C` back as length-`(r-1)` data — this is a Lean-structuring remark; keep it as a one-sentence mathematical note (the datum's mathematical content), not Lean code.

## Out of scope
- Do NOT change any existing statement, `\lean{}` pin, or `\mathlibok` marker except where directed in (B).
- Do NOT touch the `def:hilbert_polynomial`, `def:quot_functor`, Grassmannian, or SNAP-S1 (`def:sectionGradedRing`) blocks.
- Do NOT add `\leanok`.

## References
- `references/hilbert-serre.md` → `references/hilbert-serre-algebra.tex` (Stacks tag 00K1, lines 13778–13986) — the Stacks 00K1 induction is ALREADY cited in the existing Route-2 blocks; reuse the existing verbatim quote if you touch those blocks' source lines. Do NOT add a new verbatim quote for the project-bespoke homogeneity-calculus blocks (they are original, no source).

## Expected outcome
The chapter gains an "Ambient homogeneity calculus" subsubsection with 8–10 project-bespoke blocks (the 11 Lean helpers, minus the private one) carrying accurate `\lean{}`/`\uses{}`, wired into `lem:graded_subquotient_ker_coker` and `lem:graded_subquotient_degreewise_diff`; and the finiteness-encoding recipe (`adjoinCommRingOfComm` + `aeval` + `Module.compHom` + `eval(last=0)` surjection transfer) is written into `lem:graded_subquotient_finite_transfer`/`lem:graded_subquotient_isRatHilb`. `leandag` shows zero isolated nodes for the new blocks and zero `unknown_uses`.
