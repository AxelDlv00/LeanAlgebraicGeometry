# Blueprint Writer Directive

## Slug
cech-bridge

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Strategy context

This is the consolidated chapter for the one remaining geometric Lean file. Two independent
critics (blueprint-reviewer + strategy-critic) found that the iter-009 rewrite of
`lem:cech_to_cohomology_on_basis` is **mathematically circular** and must be repaired this
round before any prover runs. The project proves the protected goal
`cech_computes_higherDirectImage` via Route A (acyclic-resolution / Cartan–Leray): the
augmented Čech complex is a resolution of `F` whose terms are `f_*`-acyclic, and the P4 engine
`lem:acyclic_resolution_computes_derived` (already proved, axiom-clean) converts that into
`Hⁱ(f_* C•) ≅ Rⁱf_* F`.

**The circularity.** Route A's term-acyclicity, and the proof of the basis lemma, both reduce
to affine Serre vanishing `H^q(Spec A, qcoh)=0` (Stacks 02KG, `lem:affine_serre_vanishing`).
The current chapter tries to obtain affine vanishing *from the P3 standard-cover contracting
homotopy alone* ("term-acyclicity from the same prime-local contracting homotopy"). This is
false: the homotopy proves the Čech *complex* is exact (a resolution); term `G`-acyclicity is
`H^q` on a *smaller* affine `D(f_σ)` — the very statement being proved, with no inductive base.
The DAG currently hides the cycle only because the proof's `\uses{}` omits the implicit
`lem:affine_serre_vanishing` edge; adding it would expose a cycle
(`affine_serre_vanishing → cech_to_cohomology_on_basis → affine_serre_vanishing`).

**The fix (Stacks, torsor-free).** Affine vanishing genuinely requires the minimal Čech↔derived
bridge: injective `O_X`-modules are Čech-acyclic, plus a dimension-shift. This is irreducible —
comparing the explicit Čech complex to the injective-resolution-defined `rightDerived` must
cross "injectives are Čech-acyclic." Crucially the FULL Stacks-01EO bootstrap (the torsor `H¹`
identification `lemma-cech-h1` and `lemma-kill-cohomology-class`) is genuinely **avoidable**;
the dimension-shift route needs only `injective_cech_acyclic` + `ses_cech_h1`.

All line numbers below refer to `references/stacks-cohomology.tex` (already present), which you
must open and quote verbatim for each new block's `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF`.

## Required content

### (A) Author the minimal Čech↔derived bridge (NEW blocks)

Insert these new blocks in dependency order, BEFORE `lem:affine_serre_vanishing` /
`lem:cech_to_cohomology_on_basis` in the "Affine acyclicity" section. Each is over a general
ringed space `X` with `O_X`-modules (the project's `X.Modules` / `Scheme.Modules`), an open
covering `𝒰 : U = ⋃ U_i`, and Čech cohomology `Ȟ^p(𝒰, F)`.

1. `\lemma` `\label{lem:injective_cech_acyclic}` — **Injective `O_X`-modules are Čech-acyclic.**
   For an injective `O_X`-module `I` and any open covering `𝒰`, `Ȟ^p(𝒰, I) = 0` for all `p > 0`
   (and `Ȟ^0(𝒰,I) = I(U)`). `\lean{AlgebraicGeometry.injective_cech_acyclic}` [expected].
   Source: Stacks `lemma-injective-trivial-cech`, `references/stacks-cohomology.tex` L1407–1431
   (statement) — the proof rests on `lemma-cech-cohomology-derived-presheaves` (L1287–1398).
   Proof sketch: an injective `O_X`-module is injective as a presheaf of `O_X`-modules
   (sheafification is an exact left adjoint to the inclusion, so it preserves injectives); the
   Čech cohomology functors `Ȟ^p(𝒰,-)` are the right derived functors of the left-exact
   `Ȟ^0(𝒰,-)` on `PMod(O_X)` (which has enough injectives), and `Hom(K(𝒰)•, I) = Č•(𝒰,I)`
   with `K(𝒰)•` quasi-isomorphic to `O_𝒰[0]`, so `Ȟ^p(𝒰,I)=0` for `p>0` by exactness of
   `Hom(-,I)`. Keep the proof at this level (cite the δ-functor universality / double-complex
   facts as the Stacks lemmas they are); do NOT expand the full δ-functor construction into the
   chapter — note in the prose that the presheaf-level Čech machinery (`PMod(O_X)` enough
   injectives, Čech-complex-exact-as-a-functor) is a from-scratch Mathlib gap the prover builds.

2. `\lemma` `\label{lem:ses_cech_h1}` — **SES + cofinal Čech-`H¹` vanishing ⟹ sections
   surjective.** For a short exact sequence `0 → F → G → H → 0` of `O_X`-modules and an open
   `U`, if there is a cofinal system of coverings `𝒰` of `U` with `Ȟ^1(𝒰, F) = 0`, then
   `G(U) → H(U)` is surjective (equivalently the SES is exact on sections over such `U`).
   `\lean{AlgebraicGeometry.ses_cech_h1}` [expected]. Source: Stacks `lemma-ses-cech-h1`,
   `references/stacks-cohomology.tex` L1593–1628. Proof sketch: lift `s ∈ H(U)` locally to
   `s_i ∈ G(U_i)` on a cover refining to one with `Ȟ^1(𝒰,F)=0`; the differences
   `s_{i_0 i_1} = s_{i_1} - s_{i_0}` lie in `F(U_{i_0 i_1})` and are a Čech 1-cocycle; vanishing
   `Ȟ^1` gives `t_i ∈ F(U_i)` with `s_{i_0 i_1} = t_{i_1} - t_{i_0}`, so `s_i - t_i` glue to a
   section of `G` over `U` lifting `s`.

### (B) Repair `lem:cech_to_cohomology_on_basis` (REWRITE — break the cycle)

Keep the statement as the **genuine Stacks 01EO basis criterion** (general ringed space `X`,
basis `ℬ`, a set `Cov` of admissible coverings satisfying (1) all `U, U_i, U_{i_0…i_p} ∈ ℬ`,
(2) for each `U ∈ ℬ` the covers in `Cov` are cofinal among coverings of `U`, (3) `Ȟ^p(𝒰,F)=0`
for `p>0` for every `𝒰 ∈ Cov`): then `H^p(U,F)=0` for `p>0` and every `U ∈ ℬ`. This is exactly
what the proof below establishes — it resolves the statement↔proof mismatch the reviewer flagged.

Replace the circular proof with the genuine **dimension-shift** proof (Stacks
`lemma-cech-vanish-basis`, `references/stacks-cohomology.tex` L1716–1773): embed `F ↪ I` into an
injective `O_X`-module; `Ȟ^p(𝒰,I)=0` for `p>0` by `lem:injective_cech_acyclic`; set
`Q = I/F`; by `lem:ses_cech_h1` and (2) the SES `0→F→I→Q→0` is exact on sections over each
`U ∈ ℬ`, hence gives a SES of Čech complexes (using (1)) and a long exact Čech-cohomology
sequence, so `Q` again has vanishing higher Čech cohomology for all `𝒰 ∈ Cov`; the sheaf-LES
plus `H^n(U,I)=0` (injective) bootstraps `H^1(U,F)=0`, and induction on the LES (with `Q` in the
role of `F`) gives `H^p(U,F)=0` for all `p>0`.

- Set the proof block `\uses{lem:injective_cech_acyclic, lem:ses_cech_h1, lem:cech_acyclic_affine}`
  and **explicitly do NOT** list `lem:affine_serre_vanishing` (that lemma consumes THIS one — the
  cycle is broken because the dimension-shift never uses affine sheaf vanishing as an input;
  condition (3) is supplied by standard-cover Čech vanishing `lem:cech_acyclic_affine`).
- Update the prose: delete every claim that term-acyclicity / affine vanishing "follows from the
  contracting homotopy with no sheaf-cohomology input" and the acyclic-resolution-route argument.
- `lem:affine_serre_vanishing` (02KG) then follows by instantiating this lemma with `ℬ` = affine
  opens, `Cov` = standard affine covers, (3) from `lem:cech_acyclic_affine` — its existing proof
  prose is correct; just ensure its `\uses{lem:cech_acyclic_affine, lem:cech_to_cohomology_on_basis}`
  is intact.

### (C) Add the P3 standard-cover Lean type

The non-protected `lem:cech_acyclic_affine` (`AlgebraicGeometry.CechAcyclic.affine`) will be
re-signed from a general `X.OpenCover` to a standard-cover bundle. Add:

3. `\definition` `\label{def:standard_affine_cover}` — **Standard affine cover from a spanning
   family**, as a `\mathlibok` Mathlib-dependency anchor. State: given a commutative ring `R` (or
   `A = Γ(Spec A)`) and a family `s : ι → R` with `Ideal.span (Set.range s) = ⊤`, the standard
   open cover of `Spec R` by the basic opens `D(s_i)`, with `Γ(D(s_i)) = R_{s_i}` (the `Away`
   localisation). `\lean{AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop}`, marked
   `\mathlibok` (this IS Mathlib: `Mathlib.AlgebraicGeometry.Cover.Open`; the defining equation
   `affineOpenCoverOfSpanRangeEqTop_f i = Spec.map (algebraMap R (Localization.Away (s i)))`
   gives the `D(f_i)`-with-sections `R_{s_i}` description). Source pointer: name the Mathlib
   module; no Stacks SOURCE QUOTE needed for a Mathlib anchor.

Then update `lem:cech_acyclic_affine`'s statement prose + `\lean{}` hint to record that the
narrowed signature takes the spanning bundle `(s : ι → A) (hs : Ideal.span (Set.range s) = ⊤)`
(via `def:standard_affine_cover`) in place of the general `X.OpenCover`, and that positive-degree
exactness is obtained node-by-node by `exact_of_isLocalized_span` (localising at the spanning
elements `Away (f_r)`, after which `i_fix = r` contracts the localised complex globally) — the
contracting homotopy `h(s)_{i₀…iₚ} = s_{r i₀…iₚ}`. Do NOT change the existing contracting-homotopy
SOURCE QUOTE PROOF; this is a guidance addition to the prose, naming the Mathlib idioms
`exact_of_isLocalized_span` (`Mathlib.RingTheory.LocalProperties.Exactness`) and
`affineOpenCoverOfSpanRangeEqTop`.

### (D) Fix `lem:higher_direct_image_presheaf`

- Add the missing instance hypothesis to the statement prose: the lemma holds under
  `[HasInjectiveResolutions X.Modules]` (since `higherDirectImage = (pushforward f).rightDerived`
  is defined only when injective resolutions exist; see the NOTE on `def:higher_direct_image`).
- Add to the proof sketch an explicit caveat: the `rightDerived ↔ sheafification-of-cohomology-
  presheaf` comparison is a **from-scratch build for `Scheme.Modules`** — Mathlib provides it
  only for `Sheaf J AddCommGrpCat` (the wrong category), so the prover must build the comparison
  directly with `X.Modules` injective resolutions (or via a functor comparison into the
  `AddCommGrpCat`-level result). Keep the existing Stacks 01XJ SOURCE QUOTE.

### (E) Citation + `\uses` hygiene

- Move the `% SOURCE QUOTE PROOF:` block of `lem:cech_to_cohomology_on_basis` (currently inside
  the `\begin{lemma}…\end{lemma}` environment) to sit **immediately before** the `\begin{proof}`
  environment, per citation discipline. Use the verbatim Stacks `lemma-cech-vanish-basis` proof
  text (L1716–1773) as the new `% SOURCE QUOTE PROOF`.
- In `lem:open_immersion_pushforward_comp`, remove `lem:acyclic_resolution_computes_derived` from
  the **statement** block's `\uses{}` (keep it in the proof block's `\uses{}` only — it is a proof
  tool, not a statement dependency).

## Out of scope

- Do NOT author the torsor sub-theory: no `lemma-cech-h1` (Čech-`H¹` = torsors), no
  `lemma-kill-cohomology-class`. The dimension-shift bridge needs only items (A1)(A2).
- Do NOT touch `Cohomology_AcyclicResolution.tex` or `Cohomology_HigherDirectImage.tex` (other
  chapters; flag cross-chapter issues in your report instead).
- Do NOT add or remove `\leanok` markers (deterministic `sync_leanok` owns them).
- Do NOT mark `\mathlibok` on any block other than `def:standard_affine_cover` (the genuine
  Mathlib cover anchor). The bridge lemmas and `cech_to_cohomology_on_basis` are project
  obligations to prove.
- Do NOT rewrite the P4-side or the already-correct Route-A blocks (`lem:cech_augmented_resolution`,
  `lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology`) beyond the `\uses` hygiene
  in (E).

## References
- `references/stacks-cohomology.tex` (PRESENT — open it and quote verbatim): `lemma-injective-trivial-cech`
  L1407–1431; `lemma-cech-cohomology-derived-presheaves` L1287–1398; `lemma-ses-cech-h1` L1593–1628;
  `lemma-cech-vanish` L1630–1693; `lemma-cech-vanish-basis` (01EO) L1695–1773; `lemma-describe-higher-direct-images`
  (01XJ) ~L591.
- `references/stacks-coherent.tex` (PRESENT): `lemma-quasi-coherent-affine-cohomology-zero` (02KG, affine
  Serre vanishing) ~L145; `lemma-cech-cohomology-quasi-coherent-trivial` (standard-cover vanishing) ~L44.
- `analogies/p3-localisation.md` (PRESENT): the P3 cover-type + `exact_of_isLocalized_span` alignment for the
  `def:standard_affine_cover` prose.
- If you discover a needed source not present, you may spawn a reference-retriever (your write-domain
  includes `references/**`).

## Expected outcome

`Cohomology_CechHigherDirectImage.tex` with: a non-circular `lem:cech_to_cohomology_on_basis`
proved via the minimal torsor-free bridge (`lem:injective_cech_acyclic`, `lem:ses_cech_h1`,
dimension shift), with an honest general-01EO statement and a correct acyclic `\uses{}` graph
(no `affine_serre_vanishing → cech_to_cohomology_on_basis` cycle, no missing edge); a new
`def:standard_affine_cover` Mathlib anchor + updated `lem:cech_acyclic_affine` signature
guidance; a correctly-hypothesised `lem:higher_direct_image_presheaf` with a from-scratch caveat;
and the citation/`\uses` hygiene fixes — all source-quoted verbatim from the present Stacks files.
