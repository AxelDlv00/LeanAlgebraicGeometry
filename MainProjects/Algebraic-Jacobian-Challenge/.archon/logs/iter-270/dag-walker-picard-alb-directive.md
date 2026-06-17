# DAG Walker Directive

## Slug
picard-alb

## Seed
thm:albanese_universal_property

## Strategy context
The positive-genus arm of the Jacobian witness (`def:positiveGenusWitness`)
consumes Route A: the Picard scheme via FGA representability, plus the Albanese
universal property of Pic^0. The two route heads are
`thm:fga_pic_representability` (Picard_FGAPicRepresentability.tex) and
`thm:albanese_universal_property` (Albanese_AlbaneseUP.tex). Beneath them sits
the entire Picard/Albanese build-out: the relative Picard functor and its étale
sheafification, the Quot scheme and flattening stratification, relative Spec,
the tensor-object substrate (sheaf of k-modules, dual/inverse, internal hom),
line-bundle pullback/coherence, Pic^0 as an abelian variety (tangent space,
smoothness, properness, geometric irreducibility), the identity component, and
the Albanese descent chain (symmetric powers → Abel–Jacobi → Auslander–Buchsbaum
→ codim-1 extension → Thm 3.2 rational-map extension → coheight bridge). These
chapters have substantial intra-chapter wiring already (TensorObjSubstrate is the
best-wired chapter in the project) but the heads and many cross-chapter edges are
missing, leaving the Route-A cone disconnected from the spine.

## Depth / scope
**Your write domain is ONLY chapters matching `Picard_*.tex` and
`Albanese_*.tex`.** Three parallel walkers own the other regions — do NOT edit
Jacobian/AbelJacobi/Genus, Rigidity, or Cohomology/RiemannRoch chapters.

Walk UP from BOTH route heads — `thm:albanese_universal_property` AND
`thm:fga_pic_representability` — and make the Picard+Albanese cone complete:

1. For each isolated node in your chapters (use `archon dag-query ancestors` on
   both heads and `leandag show isolated --json` filtered to your chapters), add
   the `\uses{}` edges its proof actually invokes, intra- and inter-chapter
   within your region.
2. Wire the FGA representability chain: `thm:fga_pic_representability` `\uses`
   the relative Picard functor + étale sheafification (Picard_RelPicFunctor),
   the Quot/Hilbert prerequisites (Picard_QuotScheme,
   Picard_FlatteningStratification), relative Spec (Picard_RelativeSpec), and the
   line-bundle quot correspondence. Then `thm:pic0_smooth` / `thm:pic0_proper` /
   the Pic^0-as-abelian-variety chain (Picard_Pic0AbelianVariety,
   Picard_IdentityComponent) `\uses` representability + the tensor-object
   substrate (Picard_TensorObjSubstrate) and line-bundle chapters
   (Picard_LineBundlePullback, Picard_LineBundleCoherence,
   Picard_SheafOverEquivalence).
3. Wire the Albanese descent chain: `thm:albanese_universal_property` `\uses` the
   symmetric-power / Abel–Jacobi morphism lemmas (Albanese_AlbaneseUP) and the
   indeterminacy-extension chain (Albanese_Thm32RationalMapExtension,
   Albanese_CodimOneExtension, Albanese_AuslanderBuchsbaum,
   Albanese_CoheightBridge).
4. Where the cone bottoms out at a Mathlib result with no project block, author a
   Mathlib dependency anchor (`\mathlibok` + `\lean{<real decl>}` +
   `\textit{Provided by Mathlib.}`) ONLY if you can name the genuine Mathlib
   declaration; otherwise report it.

**Boundary rule:** `def:positiveGenusWitness` (Jacobian.tex) is owned by the
Backbone walker, which adds the edges down to your two route heads. You do NOT
edit Jacobian.tex. Stop at the top of your region; record the handoff.

For any node in your chapters with a real statement but no `\lean{}` and not a
`\begin{remark}`, add a placeholder `\lean{AlgebraicGeometry.TODO.<name>}`. The
`lem:quot_boundedness` / `lem:generic_flatness_algebraic` family and similar
decomposition aids should get placeholder pins rather than remaining unpinned.

Do NOT add `\leanok`. Do NOT invent new mathematics; transcribe dependencies.
Genuinely proof-less ∞ nodes (Route-A representability frontier) go under "Could
not complete" — those are known prover-frontier items, not your job to prove.

## References
- `references/kleiman-picard.md` (Kleiman, FGA, §4 existence, §5 Pic^0, §6 Pic^τ).
- `references/nitsure-hilbert-quot.md` (Nitsure, Quot/Hilbert construction).
- `references/abelian-varieties.md` (Milne, Albanese UP Prop 6.1/6.4 §III.6).
- `references/stacks-constructions.md` (relative-spec tags — see caveats in the
  pointer file). Cite verbatim from the local files only; never from memory.
