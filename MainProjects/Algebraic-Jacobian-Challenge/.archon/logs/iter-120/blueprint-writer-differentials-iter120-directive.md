# Blueprint-writer directive — `Differentials.tex` (Option iii rewrite)

## Target

`blueprint/src/chapters/Differentials.tex` (single chapter).

## What changed and why

The iter-120 plan agent decided to refactor `smooth_locally_free_omega`'s
signature in the Lean file to conclude on the appLE algebra Kähler
module `Ω[Γ(X, V) ⁄ Γ(S, U)]` directly, instead of through the
relative cotangent presheaf section module
`(relativeDifferentialsPresheaf f).presheaf.obj (.op V)`. Rationale:
the project-local lemma `relativeDifferentialsPresheaf_obj_kaehler`
(body `rfl`) identifies the section module with the Kähler module of a
ring map whose **source** is the colimit ring
`A_colim := ((TopCat.Presheaf.pullback CommRingCat f.base).obj
  S.presheaf).obj (.op V) = colim_{f V ⊆ W ⊆ S} Γ(S, W)` — NOT
`Γ(S, U)` for any affine `U ⊆ S`. Hence the iter-118 statement (which
phrased the conclusion in presheaf form) requires an additional bridge
`Ω[Γ(X, V) ⁄ Γ(S, U)] ≃ₗ Ω[Γ(X, V) ⁄ A_colim]` whose proof needs ~200–400
LOC of cofinality + colimit-of-localizations machinery that is out of
autonomous-loop scope.

The new statement (algebra-Kähler form) sidesteps the bridge. The
`relativeDifferentialsPresheaf` construction survives in the file as a
leaf object, with its bridge to the algebra-Kähler form documented as a
Mathlib gap.

## What you must do this iter

Rewrite the chapter `blueprint/src/chapters/Differentials.tex` to match
the new statement shape and to document the bridge as an out-of-scope
Mathlib gap. The chapter currently has the following structure (line
references are pre-edit):

- L1–8 chapter intro + downstream-role paragraph.
- L9–42 Section 1: "The relative cotangent presheaf"
  (`def:relative_kaehler_presheaf` + `lem:relative_kaehler_presheaf_obj`
  + `rem:kahler_compatibility`).
- L44–119 Section 2: "Smoothness criterion for Ω_{X/S} (forward
  direction)" — `thm:smooth_locally_free_omega` and its proof, plus
  `rem:smooth_class_naming`.
- L121–154 Section 3: "Converse direction — out of autonomous-loop
  scope" (counterexample + Mathlib converse-lemma + Stacks 02G1 ref).
- L156–177 Section 4: "Content out of autonomous-loop scope" (4 trimmed
  items).

### Required edits

1. **Rewrite Section 2 (L44–119) in full.** The new
   `thm:smooth_locally_free_omega` block must match the Lean signature
   produced by the refactor agent this iter:

   ```latex
   \begin{theorem}
     [Smooth implies Ω locally free (algebra-Kähler form)]
     \label{thm:smooth_locally_free_omega}
     \lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}
     \uses{...}
     Let $f \colon X \to S$ be a morphism of schemes and let $n \in
     \mathbb{N}$. If $f$ is smooth of relative dimension $n$, then for
     every point $x \in X$ there exist an affine open $U \subseteq S$,
     an affine open $V \subseteq X$ with $x \in V$ and $V \subseteq
     f^{-1}(U)$, such that the K\"ahler differential module
     \[
       \Omega_{\Gamma(X, V) \,/\, \Gamma(S, U)}
     \]
     (over the appLE algebra structure $\Gamma(S, U) \to \Gamma(X, V)$
     induced by $f$) is a free $\Gamma(X, V)$-module of rank $n$.
   \end{theorem}
   ```

   The proof block must:
   - Drop Step 5 ("transfer the module structure back to $M_U$") in
     its entirety — there is no longer any bridge to transfer.
   - Keep Steps 1–4 (chart extraction via `mk_iff`, pass to
     `Algebra.IsStandardSmooth`, free Kähler module, rank). Add a
     Step 4.5 for the `Nontrivial` side condition via
     `Scheme.component_nontrivial` (since this is now explicit in the
     proof, not absorbed into the bridge).
   - End cleanly: "as $x$ was arbitrary, the statement follows."
   - The Mathlib-name summary at the end should list **five** verified
     names instead of the previous six (the project-local
     `lem:relative_kaehler_presheaf_obj` is no longer in the chain).

2. **Add a new section between Section 2 and Section 3** titled
   "Bridge to the relative cotangent presheaf — out of autonomous-loop
   scope" (label: `sec:bridge-out-of-scope`). This section documents:

   - **Why** the project keeps both the algebra-Kähler form (in the
     theorem above) and the presheaf form (the
     `relativeDifferentialsPresheaf` construction in Section 1): the
     two represent the same mathematical object globally, but on a
     single affine chart they are isomorphic via a non-trivial
     `Γ(X, V)`-linear iso whose construction requires presheaf-level
     cofinality.
   - **The bridge statement.** A `\begin{remark}` block stating the
     iso under `IsAffineOpen U`, `IsAffineOpen V`, `V ≤ f ⁻¹ᵁ U`:
     \[
       (\mathrm{relativeDifferentialsPresheaf}\,f).\mathrm{presheaf}(V)
       \;\cong_{\Gamma(X, V)}\;
       \Omega_{\Gamma(X, V) \,/\, \Gamma(S, U)}.
     \]
     Use `\label{rem:bridge_relative_kaehler_iso_appLE}` and DO NOT
     include a `\lean{...}` hint (the bridge is not implemented in
     Lean this iter).
   - **The proof sketch** of the bridge (informational only, for the
     mathematician reader and for future iters): under the affine
     hypotheses, the canonical map
     $\Gamma(S, U) \to A_{\mathrm{colim}} := \mathrm{colim}_{f V
     \subseteq W \subseteq U} \Gamma(S, W)$ is a localization of
     $\Gamma(S, U)$ at the multiplicative set
     $M := \{g \in \Gamma(S, U) : \mathrm{appLE}_{f, U, V}(g) \in
     \Gamma(X, V)^\times\}$ (see e.g.\ the mathlib-analogist analysis
     in `analogies/cotangent-presheaf-design.md`). Hence
     $\Omega_{A_{\mathrm{colim}} / \Gamma(S, U)} = 0$ (Kähler module
     of a localization is zero), so by the second fundamental exact
     sequence the surjection
     $\Omega_{\Gamma(X, V) / \Gamma(S, U)} \twoheadrightarrow
       \Omega_{\Gamma(X, V) / A_{\mathrm{colim}}}$
     is an isomorphism (Mathlib:
     `KaehlerDifferential.isLocalizedModule_map`).
   - **Why this iso is out of autonomous-loop scope**: explicit
     construction requires the cofinality of the affine-open subset
     `{W ⊆ U : f V ⊆ W}` in the colimit cone of
     `{W ⊆ S : f V ⊆ W}`, an argument with no off-the-shelf Mathlib
     packaging in `b80f227`. Estimated cost if a future iter or
     downstream user needs it: 200–400 LOC.
   - **No `\lean{...}` hint** anywhere in this section. The iso is not
     implemented.

3. **Update `lem:relative_kaehler_presheaf_obj` (L19–37) to clarify
   the source ring.** The current prose says

   > In particular, on an affine open $V = \Spec B \subseteq X$ whose
   > image lies in an affine open $U = \Spec A \subseteq S$, the
   > right-hand side coincides with the classical ring-theoretic
   > $\Omega_{B/A}$.

   This is FALSE as stated (the source ring is the colimit
   `A_colim`, not `Γ(S, U)`). Rewrite this remark accurately: the
   right-hand side identifies with the Kähler module over the
   inverse-image-presheaf section ring
   `(f^{-1}_{\mathrm{psh}} \struct{S})(V)`, and the **iso** with the
   classical `Ω_{B/A}` is the content of the bridge documented in the
   new Section "Bridge to the relative cotangent presheaf —
   out-of-autonomous-loop scope". Mention the section by label.

4. **Update the chapter intro (L1–8).** The downstream-role paragraph
   currently says "smoothness of $f$ implies pointwise local freeness
   of $\Omega_{X/S}$". Reword to: "smoothness of $f$ implies the
   appLE algebra Kähler differential $\Omega_{B/A}$ is free of rank
   $n$ on every affine chart `V → U`. The relationship between this
   algebra-Kähler form and the section module of the relative
   cotangent presheaf $\Omega_{X/S}$ is documented in
   Section~\ref{sec:bridge-out-of-scope}."

5. **Delete the `% NOTE:` block at L92–104** of the existing proof. It
   is replaced by the new prose and the new Section
   "Bridge to the relative cotangent presheaf — out-of-autonomous-loop
   scope".

6. **Section 3 (Converse direction)** is fine; leave it intact.

7. **Section 4 (Content out of autonomous-loop scope, L156–177)** is
   fine; leave its 4 trimmed items intact. (The new bridge section is
   a separate concern from these 4 items.)

## What NOT to do

- Do NOT touch any other chapter file.
- Do NOT add a `\begin{lemma}` block for the bridge — make it a
  `\begin{remark}` so it carries no formalization obligation.
- Do NOT add a `\lean{...}` hint for the bridge. The bridge is NOT
  implemented in Lean this iter; the algebra-Kähler-form theorem
  doesn't need it.
- Do NOT speculate beyond the directive — the strategy-critic and
  mathlib-analogist reports establish the math; you are just writing
  prose that matches.

## Cross-check with adjacent reports

- `task_results/strategy-critic-iter120.md` — strategy-critic agrees
  Option (iii) is the right choice.
- `task_results/mathlib-analogist-cotangent-presheaf.md` — analogist
  confirms `A → A_colim` is a localization and gives the
  `KaehlerDifferential.isLocalizedModule_map` Mathlib lemma name.
- `task_results/blueprint-reviewer-iter120.md` — reviewer originally
  recommended a `\begin{lemma}` block for a bridge HELPER lemma
  (Option (i) framing); this iter we adopt Option (iii) instead, so
  the bridge is a `\begin{remark}` documenting the Mathlib gap, NOT a
  `\begin{lemma}` we will formalize.
- `analogies/cotangent-presheaf-design.md` — persistent design note
  with full mathematical recipe for the bridge if ever pursued.

## Output

Write to `blueprint/src/chapters/Differentials.tex`. Report:
- Lines of prose added / removed (approximate).
- Confirmation that the L92–104 `% NOTE:` block is gone.
- Confirmation that the new `sec:bridge-out-of-scope` section exists
  with a `\begin{remark}` block labeled
  `rem:bridge_relative_kaehler_iso_appLE` and no `\lean{...}` hint.
- Confirmation that the `thm:smooth_locally_free_omega` block matches
  the new Lean signature (algebra-Kähler form).
- Any `\uses{...}` updates you made (the new theorem statement no
  longer uses `lem:relative_kaehler_presheaf_obj` directly).

## Write-domain

`blueprint/src/chapters/Differentials.tex` (single file).
