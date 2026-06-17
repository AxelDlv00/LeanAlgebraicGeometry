# Blueprint Writer Directive

## Slug
jacobian-iter127

## Iter
127

## Chapter to edit
`blueprint/src/chapters/Jacobian.tex`

## Strategy context

Iter-127 strategic update: the over-k path is COMMITTED (per `analogies/cotangent-vanishing-pile-over-k.md`). M2.c (Galois descent of morphism equality, sub-step C.2.f in this chapter) is DROPPED; the over-k rigidity declaration `rigidity_over_kbar` (filename retained, rename to `rigidity_over_k` deferred iter-128+) is invoked DIRECTLY in the C(k) ≠ ∅ branch with the supplied $k$-rational marked point as the pointing hypothesis. No base-change-and-descent step is performed.

The iter-127 plan agent dispatched `refactor-m2b-scaffold-iter127` which added `genusZeroWitness C h : JacobianWitness C` at `Jacobian.lean:174–178` (single `sorry` body). The blueprint chapter must (a) document this new declaration; (b) add a `\uses{thm:rigidity_over_kbar}` cross-reference to register the dependency in the dependency graph; (c) update the C.2.f Galois-descent sub-step to mark it as DROPPED under the over-k path.

## Required edits

1. **Add a new theorem block for `genusZeroWitness`** at the location matching the C.3 trivial-witness paragraph (currently around L361). Render it as:
   ```latex
   \begin{theorem}[Genus-0 Albanese witness]
     \label{def:genusZeroWitness}
     \lean{AlgebraicGeometry.genusZeroWitness}
     \uses{def:JacobianWitness, thm:rigidity_over_kbar, def:genus}
     Let $C \in \mathrm{Over}\,(\Spec k)$ be a smooth proper geometrically irreducible curve over $k$ with $\genus(C) = 0$. Then there exists a \texttt{JacobianWitness}\,$C$ whose underlying scheme is $\Spec k$, with the trivial group structure, smoothness of relative dimension $0$, properness, and geometric irreducibility, and whose \texttt{isAlbaneseFor} field encodes the Albanese universal property for every $k$-rational marked point $P : \mathbf{1} \to C$.
   \end{theorem}

   \begin{proof}
     \uses{thm:rigidity_over_kbar, thm:GrpObj_eq_of_eqOnOpen}
     ... [your informal proof sketch follows; see below] ...
   \end{proof}
   ```
   The proof sketch must cover:
   - **Underlying scheme**: $J := \mathbf{1}$, the terminal object of $\mathrm{Over}\,(\Spec k)$ (which is $\Spec k$ viewed as a scheme over itself).
   - **Group / smoothness / properness / geometric-irreducibility**: standard properties of the terminal object; geometric irreducibility uses the project's `geometricallyIrreducible_id_Spec` (`Jacobian.lean:120–126`).
   - **Smoothness of relative dimension `genus C`**: after `rw [h]`, the goal becomes `SmoothOfRelativeDimension 0 (𝟙 _)` which is a Mathlib instance.
   - **`isAlbaneseFor` field**: for every $P : \mathbf{1} \to C$, exhibit the universal data: $\alpha := \mathrm{toUnit}\, C : C \to \mathbf{1}$ is the unique terminal morphism; the conclusion $P \circ \alpha = \eta_J$ is automatic since $J = \mathbf{1}$. The unique factorisation claim for $f : C \to A$ with $P \circ f = \eta_A$ reduces to $f = \mathrm{toUnit}\, C \circ \eta_A$, which is exactly the conclusion of `rigidity_over_kbar` (\cref{thm:rigidity_over_kbar}); the existence-of-$g$ part is then $g := \eta_A : \mathbf{1} \to A$, uniqueness is by the universal property of $\mathbf{1}$.
   - **Vacuity for the $C(k) = \emptyset$ branch**: when no $P : \mathbf{1} \to C$ exists, the universal quantifier $\forall P, \mathtt{IsAlbanese}\,C\,P\,J$ is trivially satisfied at the Lean type level (Lean's `∀` over an empty type is vacuously true). The proof handles this branch implicitly.
   - **Body closure status**: the Lean body is currently `sorry`; the closure is gated on the M2.a body (`rigidity_over_kbar` body, iter-138+ after pieces (i)+(ii)+(iii) of the shared cotangent-vanishing pile land); add a `\notready` marker.

2. **Update sub-step C.2.f** (the Galois-descent paragraph at line 352): replace its content with a one-paragraph DROPPED-iter-127 note plus a forward reference to the over-k commitment in `\cref{chap:RigidityKbar}`. The replacement text should explain:
   - Prior strategy iterations routed through Galois descent to transport rigidity from $\bar k$ back to $k$.
   - Iter-127 over-k analogist verified the cotangent-vanishing argument runs directly over $k$ (functorial shear iso for the globalisation; `Differential.ContainConstants` is k-agnostic; absolute Frobenius for char-p).
   - C.2.f is now obsolete; the C(k) ≠ ∅ branch of `genusZeroWitness` invokes `rigidity_over_kbar` directly with the supplied $k$-rational marked point.

3. **Update sub-step C.2.g** (line 354): keep the gap statement but drop the "Galois descent of morphism equality" gap mention (which was M2.c, eliminated this iter). Update the prose to reflect the over-k pile inventory only: pieces (i)+(ii)+(iii) of `\cref{sec:RigidityKbar_shared_pile}` are the active gaps; M2.c and M2.c.aux are eliminated.

4. **Update the `\paragraph{Mathlib infrastructure summary.}` section** (line 371): the route-($\gamma$) bullet currently references "Galois descent of morphism equality of schemes" as a prerequisite. Rephrase route-($\gamma$) to:
   - Reference only the shared cotangent-vanishing pile pieces (i)+(ii)+(iii) (per the over-k commitment).
   - Drop the Galois-descent prerequisite.
   - Note that the project introduces $\mathtt{genusZeroWitness}$ (\cref{def:genusZeroWitness}) to package the genus-$0$ arm of the witness existence.

5. **Update the introductory paragraph (around L6)** that says "the genus-$0$ identification is performed over $\bar k$ via base change, the rigidity statement is proved on $C_{\bar k} \cong \mathbb P^1_{\bar k}$, and the conclusion is descended to $k$ via Galois action" — replace with the over-k framing per iter-127.

6. **Optional, if time permits**: add a `\uses{def:genusZeroWitness}` to the `\begin{proof}` of `\thm{thm:nonempty_jacobianWitness}` (around L242–243) so the dependency graph registers the eventual consumption.

**Out of scope**:
- Do NOT touch the Picard-scheme Route A or symmetric-powers Route B sub-sections (those are M3 gap-analyses; not iter-127 work).
- Do NOT change protected declaration names (`Jacobian`, `IsAlbanese`, `JacobianWitness`, `nonempty_jacobianWitness`).
- Do NOT change `\leanok` / `\mathlibok` markers (the deterministic `sync_leanok` phase handles `\leanok`; semantic markers are review-agent territory).
- Do NOT remove the historical C.1 / C.2 / C.3 paragraph structure; only update the prose to reflect the iter-127 over-k commitment.

## References

- `AlgebraicJacobian/Jacobian.lean:174–178` — the newly-added `genusZeroWitness` Lean declaration.
- `analogies/cotangent-vanishing-pile-over-k.md` — the iter-127 over-k analogist's verdict + risk register.
- `STRATEGY.md` § M2 — the iter-127 over-k commitment (drop M2.c + M2.c.aux).
- `blueprint/src/chapters/RigidityKbar.tex` — the `rigidity_over_kbar` chapter (consumer endpoint for the dependency graph).

## Output / report

Per the descriptor: write to `task_results/blueprint-writer-jacobian-iter127.md` with the chapter delta summary + the new theorem block + any strategy-modifying findings.

## Acceptance criteria

- New `\begin{theorem}[Genus-0 Albanese witness]` block is added with the `\lean{AlgebraicGeometry.genusZeroWitness}` hint + `\uses{thm:rigidity_over_kbar, def:JacobianWitness, def:genus}` directive.
- The `\begin{proof}` of `genusZeroWitness` covers all 6 sub-cases listed in §1 above.
- Sub-step C.2.f is updated to DROPPED-iter-127 status with the over-k forward-pointer.
- Sub-step C.2.g and the route-($\gamma$) summary are updated to reflect the over-k commitment.
- `\notready` markers are placed where appropriate.
- Estimated chapter delta: ~50–80 lines (added theorem block + proof sketch + obsolete-section updates).
