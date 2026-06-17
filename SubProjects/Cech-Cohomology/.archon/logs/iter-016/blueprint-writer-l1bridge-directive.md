# Blueprint-writer directive — add the L1 categorical→module bridge to `lem:cech_acyclic_affine`

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — ONLY the **proof** of
`\begin{lemma}...\label{lem:cech_acyclic_affine}` (statement block is frozen/correct; do not
touch the statement, its `\lean{...}`, or its `\uses{...}`). You add prose to the existing
`\begin{proof}...\end{proof}` of that lemma.

## Strategy context (the slice that matters)
`CechAcyclic.affine` (Lean) proves standard-cover Čech-complex vanishing on an affine
`U = Spec A` for a quasi-coherent `F = M~` and a spanning family `(s : ι → A, hs : span(range s) = ⊤)`.
The proof route is factored L1 → L2 → L3:
- **L2** (Mathlib-provided): `exact_of_isLocalized_span (Set.range s) hs` — feeds each
  positive-degree node a localised exactness certificate, node by node.
- **L3** (already built, axiom-clean, in Lean namespace `AlgebraicGeometry.CombinatorialCech`):
  the explicit alternating contracting homotopy on the localised complex (`combDifferential`,
  `combHomotopy`, `combHomotopy_spec` giving `d∘h+h∘d=id`, `combDifferential_comp` giving `d²=0`,
  packaged as `combDifferential_exact : Function.Exact`). The blueprint proof already describes L3
  adequately (the contracting homotopy `h(s)_{i_0…i_p} = s_{i_fix i_0…i_p}` in the away-localisation).
- **L1** (THE GAP YOU FILL): the blueprint is currently **silent** on how the *abstract categorical*
  Čech complex `CechComplex f 𝒰 F` (degree-`p` term, an object of `QCoh(Spec R)`) is identified with
  the *concrete* away-localisation module complex `∏_{σ : Fin(p+1)→ι} M_{s_σ}` that L2/L3 operate on.

## What to add — the L1 identification paragraph
Add a paragraph to the proof of `lem:cech_acyclic_affine` that makes the following explicit, at
textbook rigor, in the project's notation:

1. For the standard cover `𝒰 = (affineOpenCoverOfSpanRangeEqTop s hs).openCover`, the `i`-th cover
   piece is `Spec(A_{s_i}) → Spec A`, i.e. the basic open `D(s_i)`. The `(p+1)`-fold intersection
   indexed by `σ : Fin(p+1) → ι` is `Spec(A_{s_σ})` where `s_σ = ∏_k s_{σ k}` (equivalently the
   localisation away from the finite product, `A_{s_{σ 0}…s_{σ p}}`).
2. Because `F = M~` is quasi-coherent, its sections over the basic open `D(s_σ)` are the away
   localisation of the module: `Γ(D(s_σ), F) = M_{s_σ}` (the `Localization.Away`/`IsLocalizedModule`
   localisation of `M` at the product `s_σ`). Hence the degree-`p` term of `CechComplex f 𝒰 F` is the
   product `∏_{σ : Fin(p+1)→ι} M_{s_σ}`.
3. The Čech differential of the abstract complex (the alternating sum of restriction maps along the
   face inclusions `D(s_{σ}) ↪ D(s_{σ∘d_j})`) is, under this identification, exactly the alternating
   sum of localisation/restriction maps `M_{s_{σ∘d_j}} → M_{s_σ}` — i.e. the concrete coboundary that
   L2's `exact_of_isLocalized_span` and L3's `combDifferential` consume. State the compatibility
   (the identification is a map of complexes), so that positive-degree exactness of the abstract
   complex follows from positive-degree exactness of the concrete localised complex.

Then conclude: with the degree-`p` identification (2) and differential compatibility (3), the
positive-degree vanishing `IsZero (homology p)` of `CechComplex f 𝒰 F` reduces to the concrete
localised-complex exactness supplied by L2 + L3 — which is the content the Lean prover must transport.

## Source / citation discipline (MANDATORY)
The key external fact is `Γ(D(f), M~) = M_f` for a quasi-coherent sheaf on an affine scheme
(sections over a basic open = away localisation of the module). Find and quote the verbatim source:
- First look in `references/stacks-coherent.tex` (the chapter's existing source; Stacks
  "Cohomology of Schemes" — the `\check H` computation and the quasi-coherent localisation set-up)
  and `references/stacks-cohomology.tex`.
- The most precise home for `\widetilde M(D(f)) = M_f` is Stacks "Schemes/Properties of Schemes"
  (constructions of quasi-coherent sheaves on affines) or Hartshorne II.5. If neither local file
  contains the verbatim statement, you are AUTHORIZED to dispatch a `reference-retriever` child
  (your `--write-domain` includes `references/**`) to fetch the original source FILE, then quote it
  verbatim. Do NOT write a `% SOURCE QUOTE:` from memory — read the local file first.
- Add the `% SOURCE:` (with `(read from references/<file>)`), `% SOURCE QUOTE:` (verbatim,
  original language/notation), and a visible `\textit{Source: …}` line per the project's citation rules.

## Out of scope (do NOT do)
- Do NOT touch the statement block, `\lean{...}`, or `\uses{...}` of `lem:cech_acyclic_affine`.
- Do NOT add or remove any `\leanok` (deterministic sync owns it). `\mathlibok` only on a genuine
  Mathlib dependency anchor if you author one (not required here).
- Do NOT edit any other lemma's proof, or any other chapter.
- No Lean tactics in the prose — mathematical content only.
