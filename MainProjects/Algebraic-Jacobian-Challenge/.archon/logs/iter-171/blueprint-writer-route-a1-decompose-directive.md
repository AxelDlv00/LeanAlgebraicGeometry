# Blueprint Writer Directive

## Slug
route-a1-decompose

## Target chapter
`blueprint/src/chapters/Picard_RelativeSpec.tex` (NEW chapter — does not yet exist)

## Strategy context

Route A is the project's **CRITICAL PATH** for the positive-genus arm of `nonempty_jacobianWitness` (the object `J = Pic⁰_{C/k}` must be a real `g`-dimensional abelian variety regardless of whether `C(k) = ∅`; Routes B/C cannot substitute for the OBJECT construction). Route A has stood deferred for 5+ iters with zero prover dispatch (progress-critic iter-171 verdict: **STUCK by inaction**). The iter-170 strategy-critic flagged "parallelism under-exploited"; iter-171 STRATEGY.md update splits Route A into 4 parallel-startable sub-rows (A.1/A.2/A.3/A.4). **The smallest entry point is A.1.a `RelativeSpec`** per `analogies/m3-route-audit.md` (iter-123) — a relative-spectrum functor `Spec_X : QCoh(X)ᵒᵖ → Sch/X` sending a quasi-coherent sheaf of algebras `𝒜` to its relative spectrum, satisfying the standard universal property and base-change compatibility. This is the foundation underneath the relative Picard functor `Pic^♯_{C/k}` (A.1).

Your job: write a NEW chapter `Picard_RelativeSpec.tex` that is **prover-ready** — i.e. detailed enough that iter-172 can dispatch a file-skeleton prover lane on `AlgebraicJacobian/Picard/RelativeSpec.lean` and a follow-up iter can fill the bodies. The chapter declares the `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean` line at the top.

Mathlib has the absolute `Spec : CommRingCatᵒᵖ ⥤ Scheme` functor and the affine-cover construction, plus partial pieces of relative-Proj (`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.*`). It does NOT have a general `RelativeSpec` functor as a packaged construction. The standard reference is **Hartshorne II §5 Exercise 5.17 (relative Spec)** and **Stacks tag 01LL** (`Spec` of a quasi-coherent sheaf of algebras); the in-tree work makes this construction project-native, with the upstream PR a follow-up.

## Required content

The new chapter must contain (in order):

1. **`% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean`** at the top (next to the `\chapter{Relative Spec}` heading).

2. **Section "Setup and motivation"** — one paragraph naming the use within Route A (relative Picard functor `Pic^♯_{C/k} = Pic(C ×_k T) / π^* Pic(T)` requires the relative-line-bundles construction on a product `C ×_k T`, which is itself a relative scheme over `T` — hence `RelativeSpec` is the foundational building block).

3. **`\begin{definition}[Quasi-coherent sheaf of algebras]` block** with `\label{def:qc_sheaf_of_algebras}` and `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (project-bespoke; no Mathlib counterpart yet). Source: Stacks tag **01LL** + **01LR**. Required content of the definition: a quasi-coherent sheaf `𝒜` of `𝒪_X`-algebras on a scheme `X` is a quasi-coherent `𝒪_X`-module `𝒜` together with an `𝒪_X`-algebra structure (multiplication, unit, distributivity). Provide a verbatim `% SOURCE QUOTE:` block from `references/stacks-coherent.md` (read the local file) of Stacks 01LL.

4. **`\begin{theorem}[Relative spectrum exists]` block** with `\label{thm:relative_spec_exists}` and `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (project-bespoke). Source: Hartshorne II Exercise 5.17 (a–c) + Stacks tag 01LQ. Required content: given a quasi-coherent sheaf of algebras `𝒜` on `X`, there exists a scheme `RelativeSpec 𝒜 = Spec_X 𝒜` together with an affine morphism `π : Spec_X 𝒜 → X` satisfying `π_* 𝒪_{Spec_X 𝒜} = 𝒜` as quasi-coherent `𝒪_X`-modules. Verbatim Stacks 01LQ as `% SOURCE QUOTE:`.

5. **`\begin{theorem}[Universal property of relative spectrum]` block** with `\label{thm:relative_spec_univ}` and `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}`. Statement: for any scheme `Y` over `X`, the set of `X`-morphisms `Y → Spec_X 𝒜` is in natural bijection with the set of `𝒪_X`-algebra maps `𝒜 → π_{Y*} 𝒪_Y`. Verbatim Stacks 01LQ continuation as `% SOURCE QUOTE:`.

6. **`\begin{theorem}[Affine base of relative spectrum]` block** with `\label{thm:relative_spec_affine_base}` and `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}`. Statement: when `X = Spec R` is affine, `Spec_X 𝒜 ≅ Spec(Γ(X, 𝒜))` (the relative spectrum reduces to the absolute spectrum of the global sections, regarded as an `R`-algebra). Verbatim Stacks 01LO as `% SOURCE QUOTE:`.

7. **`\begin{theorem}[Base change of relative spectrum]` block** with `\label{thm:relative_spec_base_change}` and `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}`. Statement: for `f : T → X` a morphism of schemes and `𝒜` a quasi-coherent sheaf of algebras on `X`, the pullback `f^*(Spec_X 𝒜) = Spec_T (f^* 𝒜)` canonically as `T`-schemes. Source: Stacks 01LS. Verbatim as `% SOURCE QUOTE:`.

8. **`\begin{theorem}[Functoriality of relative spectrum]` block** with `\label{thm:relative_spec_functorial}` and `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}`. Statement: `RelativeSpec` is a contravariant functor from the category of quasi-coherent sheaves of `𝒪_X`-algebras to the category of affine `X`-schemes; it has a left adjoint `π_* : Aff(Sch/X)ᵒᵖ → QcohAlg(X)`. Verbatim Stacks 01LR or Hartshorne II Ex 5.17(b) as `% SOURCE QUOTE:`.

9. **Section "Lean encoding"** — one paragraph (no `\begin{theorem}` block) noting that:
   - The `RelativeSpec` construction can be defined directly via gluing the local `Spec R[𝒜(R)]` along affine opens of `X`; for each affine open `U = Spec R ⊆ X`, set `Spec_X 𝒜 |_U := Spec(𝒜(U))` (using `IsAffineOpen.toScheme` + the algebra structure on `𝒜(U)`).
   - The gluing data come from the quasi-coherent transition isos `𝒜(U) ⊗_R S → 𝒜(V)` for `V = Spec S ⊆ U`.
   - Use `Mathlib.AlgebraicGeometry.AffineScheme.glueOpens` or the `Scheme.GlueData` machinery as the implementation backbone.
   - The Lean target is `AlgebraicJacobian/Picard/RelativeSpec.lean` — a NEW file iter-172+ scaffolds.

10. **Section "Out of scope"** — one paragraph listing what the chapter does NOT cover:
    - The relative Picard functor `Pic^♯_{C/k}` itself — that lives in a sibling chapter (`Picard_RelPicFunctor.tex`) once A.1.c is decomposed.
    - The line-bundle pullback functor on a product `C ×_k T` — that lives in `Picard_LineBundlePullback.tex` (A.1.b).
    - Connectedness / dimensionality / smoothness of `Spec_X 𝒜` — those are downstream properties depending on assumptions on `𝒜`.
    - Pic⁰ identity component — that's Route A.3, not A.1.

11. **Source citation block** (above the first theorem) — `% SOURCE: Hartshorne, Algebraic Geometry, II Exercise 5.17 (read from references/hartshorne-algebraic-geometry.pdf)` + Stacks tags. Reference resolution: `references/hartshorne-algebraic-geometry.pdf` is in tree (see `references/summary.md`). Stacks: `references/stacks-coherent.md` is the pointer file; the underlying Stacks chapters at tags 01LL, 01LO, 01LQ, 01LR, 01LS are in `references/stacks-coherent.tex` (read directly).

12. **`\uses{}` annotations** on each theorem block, citing the prior block(s) it depends on.

## Out of scope

- Do NOT add `\leanok` or `\mathlibok` markers (those are managed by `sync_leanok` / review agent respectively).
- Do NOT touch any other chapter file (your write-domain is `Picard_RelativeSpec.tex` only).
- Do NOT modify `content.tex` (the plan agent updates that to `\input` the new chapter).
- Do NOT cite a source you have not just read locally. If `references/hartshorne-algebraic-geometry.pdf` or `references/stacks-coherent.tex` cannot be opened, dispatch the reference-retriever (your `--write-domain` authorizes `references/**`).

## References

- `references/hartshorne-algebraic-geometry.pdf` — Hartshorne II §5 Ex 5.17 (a–c). Required for the verbatim `% SOURCE QUOTE:` of the relative-Spec universal property.
- `references/stacks-coherent.tex` — Stacks tags 01LL (qc sheaf of algebras), 01LO (affine base), 01LQ (RelativeSpec exists + UP), 01LR (functoriality), 01LS (base change). Required for the verbatim `% SOURCE QUOTE:` blocks on each statement.
- `references/kleiman-picard.pdf` §4 — for downstream context on how the relative Picard functor consumes RelativeSpec. (Optional read; not quotable from this chapter, but informs the prose.)
- `analogies/m3-route-audit.md` (iter-123) — for the prior identification of `RelativeSpec` as the smallest Route A.1 entry point.
- `blueprint/src/chapters/Jacobian.tex` L347-L432 — for the existing per-sub-phase budget that motivates this decomposition.

## Expected outcome

A NEW chapter file `blueprint/src/chapters/Picard_RelativeSpec.tex` of ~150–250 lines containing the 6 declaration blocks above with verbatim source quotes from the local reference files. Each `% SOURCE QUOTE:` is character-for-character from the named local file (no paraphrase, no translation). The chapter is prover-ready: iter-172 can dispatch a file-skeleton lane on `AlgebraicJacobian/Picard/RelativeSpec.lean` (~600-1100 LOC target). The chapter's first line declares `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean`. No `\leanok` / `\mathlibok` markers anywhere.

If you discover the Stacks tex source for the named tags is missing from `references/stacks-coherent.tex`, dispatch the reference-retriever as a child to download from `https://stacks.math.columbia.edu/download/`. If Hartshorne II.Ex.5.17 is not extractable from `references/hartshorne-algebraic-geometry.pdf` via `Read` with `pages:`, fall back to `pdftotext` and document the fallback in your report.
