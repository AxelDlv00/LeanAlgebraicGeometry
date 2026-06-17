# Strategy critic directive — iter-026 (Čech computation of R^i f_*, Ext route entering execution)

You are a fresh-context critic of the GLOBAL strategy. Read ONLY the materials named here.

## Read these (verbatim)
- `STRATEGY.md` (project root `.archon/STRATEGY.md`) — the full current strategy.
- `references/summary.md` — the reference index (sources backing the project).

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`), the
protected frozen-signature target: for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent,
`𝒰` a finite affine open cover of `X`, an isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅
higherDirectImage f i F)` where `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
Zero inline sorry in the cone, zero project axioms, kernel-only axioms.

## Blueprint chapter map (titles, one line each)
- `Cohomology_HigherDirectImage.tex` — Higher direct images R^i f_* of quasi-coherent sheaves (def of the goal target + push–pull functor).
- `Cohomology_AcyclicResolution.tex` — Abstract Leray lemma: a G-acyclic resolution computes G.rightDerived (Stacks 015E). DONE.
- `Cohomology_CechHigherDirectImage.tex` — the consolidated chapter (covers 6 Lean files): standard-cover Čech vanishing (P3, section form, DONE), the presheaf/free Čech bridge → `injective_cech_acyclic`/`ses_cech_h1` (P3b, DONE iter-024/025), absolute cohomology = Ext of the structure sheaf (`def:absolute_cohomology`, NEW), Serre vanishing 02KG (`affine_serre_vanishing`), Čech-to-cohomology on a basis 01EO (`cech_to_cohomology_on_basis`), and the frozen P5b comparison assembly.

## State entering iter-026 (factual, no narrative)
- P3 (standard-cover Čech vanishing, section form) and P3b (Čech↔derived bridge:
  `cechFreeComplex_quasiIso`, `ses_cech_h1`, `injective_cech_acyclic`) are CLOSED, axiom-clean.
- The current frontier is the endgame chain: `def:absolute_cohomology` (Ext) →
  `cech_to_cohomology_on_basis` (01EO, dimension shift via the Ext LES) →
  `affine_serre_vanishing` (02KG) → re-enables the frozen P5b goal.
- Absolute cohomology realized as `Ext^p(O_U, F|_U)` via Mathlib `CategoryTheory.Abelian.Ext`
  (Route β `Sheaf.H` refuted as absent; `Functor.rightDerived` has injective vanishing but NO
  LES; Ext is the only route with the 01EO LES off-the-shelf).

## What I want challenged
1. Is the **Ext-as-absolute-cohomology** route sound as the spine of the 01EO→02KG endgame, given
   the project's goal uses `Functor.rightDerived` for `R^i f_*` (a DIFFERENT derived-functor
   framework)? The strategy claims "no bridge lemma between Ext and rightDerived is forced." Is
   that true, or does some step silently need `H^p(U,-) (Ext) ≅ H^p(f^{-1}V,-) (rightDerived/Čech)`?
   In particular scrutinize the P5a "absolute `H^k(f^{-1}V,G)` bridge" deferred obligation — does
   realizing absolute cohomology as Ext make that bridge HARDER (now it must connect Ext to the
   sheafified-presheaf-homology engine), and is that cost accounted for?
2. Is the **acyclicity bridge** (Route A's term-/relative-acyclicity reducing to affine Serre
   vanishing 02KG, via the torsor-free P3b chain) genuinely non-circular and complete? The
   strategy claims P3 produces standard-cover Čech vanishing and P3b lifts it to affine sheaf
   vanishing without using affine vanishing as input. Verify the dependency direction holds for
   the Ext realization too.
3. Is the remaining phase decomposition (P3b residual → P5a vanishing inputs → P5b assembly)
   ordered correctly, and are the iters-left/LOC estimates plausible?
4. Any structural risk in the `restrictFunctor`-vs-`j_!` form choice for absolute cohomology
   (whether the eventual injective-vanishing obligation is a hidden multi-hundred-LOC brick)?

Output your verdict (SOUND / CHALLENGE / REJECT per route) with concrete reasoning to
`task_results/strategy-critic-iter026.md`. Do not propose Lean code.
