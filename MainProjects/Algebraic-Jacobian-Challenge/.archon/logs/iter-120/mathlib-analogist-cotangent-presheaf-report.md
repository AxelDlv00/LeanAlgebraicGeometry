# Mathlib Analogist Report

## Slug
cotangent-presheaf

## Iteration
120

## Question

Is Mathlib's `TopCat.Presheaf.pullback` (left Kan extension at the
presheaf level) the right idiom for building the relative cotangent
presheaf `Ω_{X/S}` of a morphism of schemes, given the bridge issue
between the project's section module `Ω[B / A']`
(`A' = colim_{f V ⊆ W} Γ(S,W)`) and Mathlib's appLE-algebra Kähler
module `Ω[B / A]` (`A = Γ(S, U)`)? Three structural options were
asked about (Q3: local helper lemma, sheafified-pullback refactor,
theorem restatement); a fourth question (Q4) asked for latent
parallel-API risks elsewhere in the project.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| D1: presheaf-level `pullback` for cotangent presheaf | NEEDS_MATHLIB_GAP_FILL | informational (forced by Mathlib gap, not a project choice to correct) |
| D2: appLE `A → B` vs. colimit ring `A' = A_M` relationship | iso of `Ω` modules **holds** via `KaehlerDifferential.isLocalizedModule_map` | informational (mathematically established) |
| D3a: Option (i) — local bridge lemma | DIVERGE_INTENTIONALLY (acceptable but high-risk) | major |
| D3b: Option (ii) — sheafified-pullback refactor | not recommended this iter | major |
| D3c: Option (iii) — theorem restatement on `Ω[Γ(X,V)/Γ(S,U)]` | ALIGN_WITH_MATHLIB | critical (must-fix-this-iter for the **theorem-statement** shape of `smooth_locally_free_omega`) |
| D4: latent design risks elsewhere | PROCEED (no new risks; existing risks already cataloged) | informational |

## Must-fix-this-iter

- **D3c**: `smooth_locally_free_omega` (`AlgebraicJacobian/Differentials.lean:87-136`)
  currently states its conclusion in terms of the cotangent presheaf
  `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)`. This wires
  the smoothness criterion through a load-bearing bridge to Mathlib's
  appLE-algebra Kähler chain
  (`Algebra.IsStandardSmooth.free_kaehlerDifferential` +
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`),
  even though **the cotangent presheaf has no downstream consumer in
  the live project graph** (it is a leaf object).
  - **Refactor**: restate the theorem on
    `Ω[Γ(X, V) ⁄ Γ(S, U)]` directly (the appLE algebra Kähler module).
    The body becomes the existing iter-119 Steps 1-4 with no Step-5
    bridge. The theorem `smooth_locally_free_omega` is **not** in
    `archon-protected.yaml` (only `Genus.genus`, the four
    `Jacobian` instances, and the three `Jacobian.ofCurve` /
    `comp_ofCurve` / `exists_unique_ofCurve_comp` declarations are
    protected), so restatement is allowed.
  - **Blueprint update**: Differentials.tex's
    `thm:smooth_locally_free_omega` (lines 48-114) must be restated
    to match. The iter-119 `% NOTE` block at L92-104 can be replaced
    with a brief "iter-120 refactor: forward-direction theorem stated
    affine-chart-wise to match Mathlib `IsStandardSmooth` API" note.
  - **Cost**: estimated 5-10 LOC theorem body, ~30 LOC of blueprint
    rewrite. Single prover-iter closes it (~1-2 cycles).

## Major

- **D3a, optional hybrid**: keep the cotangent presheaf and its
  `rfl` lemma (`relativeDifferentialsPresheaf_obj_kaehler`) intact;
  add an **independent** lemma
  `relativeDifferentialsPresheaf_iso_kaehler_appLE` with a `sorry`
  body that flags the bridge obligation for future downstream
  consumers. Cost this iter: 0 LOC of bridge work (the
  `sorry`-bodied lemma simply documents the gap); cost in the
  future, when a consumer needs the bridge: 200-400 LOC of
  cofinality + colimit-of-localizations argument (Decision 2 of the
  analogy file gives the full mathematical recipe).

  This is **optional** — only add it if the plan-agent wants to make
  the bridge gap visible at the file level. Otherwise, the analogy
  file `analogies/cotangent-presheaf-design.md` already captures the
  bridge obligation persistently for future iters.

- **D3b, sheafified pullback refactor**: not recommended for
  iter-120. Mathlib b80f227 has `TopCat.Sheaf.pullback` and
  `AlgebraicGeometry.Scheme.Modules.{pullback,pushforward}` but
  **no sheafified `relativeDifferentials`** functor; building one
  spans the same affine-basis-to-X sheafification gap that the
  project already declared out-of-scope in
  `analogies/affine-basis-sheaf-bridge.md`. Revisit only if a
  Mathlib update lands the missing infrastructure.

## Informational

- **D1**: the project's choice of presheaf-level `pullback ⊣
  pushforward` adjunction transpose + `relativeDifferentials'` is
  the **only off-the-shelf path in Mathlib b80f227** for building a
  cotangent presheaf at the scheme-morphism level. Mathlib has no
  scheme-level relative cotangent sheaf at this snapshot. The
  divergence from "sheafified inverse image" is forced by the
  Mathlib gap, not by a project choice that could be aligned. The
  project's path is the best one available.

- **D2 (mathematical content for the bridge, retained for the
  future)**: under `IsAffineOpen U₀ ∧ IsAffineOpen V₀ ∧ V₀ ≤ f⁻¹ U₀`,
  the colimit ring
  `A' = ((TopCat.Presheaf.pullback CommRingCat f.base).obj
  S.presheaf).obj (op V₀)` is the **localization** `A_M` of
  `A = Γ(S, U₀)` at
  `M = {g ∈ A : (Hom.appLE f U₀ V₀ e).hom g ∈ Γ(X, V₀)^×}`. The
  natural map `A → A_M` is a localization map, so `Ω[A_M / A] = 0`.
  By the second exact sequence of Kähler differentials, the surjection
  `Ω[B / A] → Ω[B / A_M]` is **an isomorphism**. The relevant Mathlib
  lemma is `KaehlerDifferential.isLocalizedModule_map`
  (`Mathlib.RingTheory.Etale.Kaehler`). The image-equality claim
  `image(A → B) = image(A' → B)` in the directive's Q2 is **false as
  a set equality** (counterexample: `f : Spec ℚ → Spec ℤ` with
  `U₀ = Spec ℤ`, `W = D(2)` gives `1/2 ∈ image(A') \ image(A)`); the
  Kähler iso holds anyway because `d(g^{-1}) = -g^{-2} dg` lives in
  the `B`-submodule already generated by `d(image(A))`.

- **D4 (latent design risks scan)**: scanned `AlgebraicJacobian/`
  and `references/challenge.lean`. The other project files were
  spot-checked:
  - `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`, `Rigidity.lean`
    are aligned with Mathlib idioms or contain clearly-flagged
    deferred existence axioms (e.g.
    `Jacobian.nonempty_jacobianWitness`'s single sorry, explicitly
    documented as the Phase-C deferred Albanese existence).
  - `Cohomology/StructureSheafModuleK.lean` introduces `Scheme.HModule`
    / `HModule'` as `ModuleCat k`-valued parallels of Mathlib's
    `Sheaf.H` / `Sheaf.H'`. This parallel API is **intentional and
    necessary** — Mathlib's cohomology infrastructure is
    `AddCommGrpCat`-valued, but `genus` needs a `Module k`-instance
    on `H¹(C, O_C)` to apply `Module.finrank`. Already analyzed in
    `analogies/c1-route.md`, `analogies/cech-koszul-precedent.md`,
    and `analogies/finite-product-localisation-and-cech-r-linearity.md`.
    No new latent risk.
  - `Cohomology/MayerVietoris*.lean` builds the Mayer-Vietoris LES
    for the `ModuleCat k`-cohomology. Same parallel-API justification
    as `HModule`; already adjudicated.

  **No new parallel-API or signature-mismatch pattern was found
  outside the already-cataloged ones.** The user-directive's
  "complete blueprints for all components" goal does not expose
  new latent risks beyond what is already analyzed in
  `analogies/*.md`.

## Persistent file
- `analogies/cotangent-presheaf-design.md` — design-rationale captured
  for future iters (Decisions 1-4 with full Mathlib citations, the
  mathematical bridge recipe for Decision 2 if Option (i) is ever
  pursued, and a recommended hybrid).

Overall verdict: **adopt Option (iii) — restate `smooth_locally_free_omega`
on `Ω[Γ(X,V) ⁄ Γ(S,U)]` directly**, eliminating the bridge from the
theorem's content and closing the iter-119 PARTIAL in a single
prover-iter; optionally landed Option (i) as a `sorry`-bodied
companion lemma to document the bridge obligation; Option (ii) and a
full Option (i) bridge are out-of-loop-scope this iter.
