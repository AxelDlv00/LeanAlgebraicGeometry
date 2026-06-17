# blueprint-writer bw-cech263 — make Cohomology_CechHigherDirectImage.tex adequate for the `CechNerve` build

## Scope
Edit `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. The chapter currently describes
the Čech nerve/complex abstractly but gives NO guidance on the actual Lean construction strategy that
the formalization is following, and carries a terminology error and undocumented weakenings
(lvb-cech262 findings). Bring the chapter up to the level of detail a prover needs.

## Context — the construction strategy the Lean file actually uses
The formalization (`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`) builds the relative Čech
complex via a clean split (all the following are already axiom-clean in the file except the one
remaining hole):
1. **Geometric backbone** — package the affine cover `𝒰` as a single arrow `∐ᵢ Uᵢ ⟶ X`
   (`coverArrow := Arrow.mk (Sigma.desc 𝒰.f)`), then take Mathlib's `Arrow.augmentedCechNerve`. Its
   degree-`p` object is the `(p+1)`-fold fibre power `∐_{(i₀…i_p)} U_{i₀} ×ₓ ⋯ ×ₓ U_{i_p}`, with the
   augmentation the cover map to `X`. Unconditional (uses only that `Scheme` has coproducts and finite
   limits). [`coverCechNerve`]
2. **Push-pull functor** `G : (Over X)ᵒᵖ ⥤ X.Modules`, `(Y, p) ↦ p_* p^* F =
   (pushforward p).obj ((Scheme.Modules.pullback p).obj F)` — the part that lifts the geometric nerve to
   a (co)simplicial object of `O_X`-modules. THIS is the lone remaining hole. Defining `G.map` for a
   morphism over `X` requires an `eqToHom` transport along the over-triangle `h ≫ Y1.hom = Y2.hom`, and
   `G.map_id`/`G.map_comp` require the `pushforwardComp`/`pullbackComp` coherence — the SAME coherence
   machinery being built in `Picard/TensorObjSubstrate.lean` (`pullbackComp_δ`, `pushforwardComp_lax_μ`,
   the `pullbackObjUnitToUnit_comp` family). So `G`'s functoriality is a CONSUMER of that machinery, not
   independent.
3. **Nerve→complex plumbing** (coherence-free) — forget the augmentation (`Augmented.drop`), push
   forward along `f` via `CosimplicialObject.whiskering (pushforward f)`, then take the alternating
   coface-map cochain complex (`alternatingCofaceMapComplex S.Modules`). Uses only preadditivity of
   `S.Modules`. [`relativeCechComplexOfNerve`; `CechComplex := relativeCechComplexOfNerve f (CechNerve 𝒰 F)`]

## What to add / fix (mathematical prose only — no Lean tactics, no `\leanok`, no markers)
1. **Promote the backbone/push-pull/plumbing split into the chapter.** Add prose (a new subsection or
   an expansion of the `def:cech_nerve`/`def:cech_complex` discussion) describing the three-part
   construction above at textbook level: the augmented-Čech-nerve-of-an-arrow backbone, the push-pull
   functor `(Y,p) ↦ p_*p^*F` that turns the geometric nerve into a (co)simplicial sheaf of modules, and
   the coherence-free alternating-coface plumbing to the cochain complex. Make explicit that the push-pull
   functoriality (`map_id`/`map_comp`) is where the `pushforwardComp`/`pullbackComp` coherence is needed
   — i.e. it is the one non-formal step, and it is the same coherence developed for the tensor-pullback
   substrate. (Do NOT name Lean identifiers like `coverArrow`/`Gobj` in the visible prose — describe the
   MATH: "package the cover as a single arrow", "the relative-direct-image functor on the over-category",
   etc. Lean names belong only in `\lean{}` tags if a decl exists.)
2. **Fix the terminology error**: the chapter calls the nerve an augmented *simplicial* object of
   modules where the complex is built from its *cosimplicial* structure (pushforward is covariant, so the
   degreewise modules form a cosimplicial object and the alternating coface maps give a *cochain* complex).
   Correct "simplicial"→"cosimplicial" wherever the module-valued nerve / the complex direction is
   described, keeping the geometric nerve (a simplicial *scheme*) correctly simplicial. State the
   variance explicitly so the cochain (not chain) direction is unambiguous.
3. **Document the two weakenings** that the Lean statements carry but the prose omits:
   - The `cech_computes_higherDirectImage` comparison is stated as a `Nonempty (≅)` (existence of an
     isomorphism), not a chosen natural iso — note this weakening and why it suffices (we only need the
     existence of the comparison for the downstream representability/loc-triv consumers).
   - The derived-functor comparison target carries a `[HasInjectiveResolutions X.Modules]` hypothesis
     (it compares the unconditional Čech `Rⁱf_*` against the injective-resolution `Rⁱf_*` only when the
     latter is defined). State this hypothesis in the relevant theorem block's prose.
4. **Flag the Mathlib gaps on the three downstream sorry'd theorems** (`cech_acyclic_affine`,
   `cech_computes_higherDirectImage`, `cech_flatBaseChange`): each depends on substantial Mathlib-absent
   infrastructure — a module-level contracting homotopy for the standard-cover Čech complex; the
   Čech-to-derived-functor and Leray spectral sequences for `Scheme.Modules`; term-wise affine base
   change of the Čech complex. Add a one-sentence "this proof depends on the following currently-absent
   Mathlib infrastructure: …" note to each so the gap is visible and the dependency order is honest.

## Out of scope
- No `\leanok`/`\mathlibok` markers.
- Do NOT attempt to write proofs for the three downstream theorems — only flag their gaps.
- Keep all existing `% SOURCE`/`% SOURCE QUOTE` blocks intact; you may add new ones only if you read
  the cited Stacks file (`references/stacks-coherent.tex`) for any NEW quoted statement. If you add no
  new quoted source statement, you need not touch the citation blocks. You have `references/**` in your
  write-domain in case a child reference-retriever is needed, but the Stacks Čech material is already
  present in `references/stacks-coherent.tex`.
