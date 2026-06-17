# Strategy Critic Report

## Slug
iter027

## Iteration
027

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Verdict**: SOUND

The augmented-Čech-as-acyclic-resolution + P4 Leray engine route is the standard
non-spectral-sequence path and is goal-aligned: it lands `Hⁱ(f_*C•) ≅ Rⁱf_*F` directly,
matching the protected `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
Its only nontrivial input (termwise `f_*`-acyclicity → affine Serre vanishing) is correctly
routed through the non-circular bridge audited below.

### Route: B — two spectral sequences (REJECTED, fallback)

- **Verdict**: SOUND (as a documented rejection)

Correctly rejected: both spectral sequences are absent from Mathlib (multi-kLOC) and Leray
additionally needs quasi-coherence of `R�q f_* F`. The strategy's honest observation that B
does *not* escape the `injective_cech_acyclic` brick (so rejecting B costs nothing) is right.
Retaining it as a one-paragraph fallback comparison is legitimate route-comparison, not
appendix history.

### Route: The acyclicity bridge (01EO → 02KG)

- **Goal-alignment**: PASS — lifts P3 standard-cover Čech vanishing to affine sheaf vanishing,
  which is exactly Route A's missing acyclicity input.
- **Mathematical soundness**: PASS — I read the Stacks 01EO proof verbatim
  (`stacks-cohomology.tex` 1716–1776) and confirmed the non-circularity claim.
- **Verdict**: SOUND

**Non-circularity confirmed against the source.** The 01EO proof consumes exactly, and only:
(i) injective embedding `F→I` (enough injectives); (ii) `lemma-injective-trivial-cech` =
`injective_cech_acyclic` (done); (iii) `lemma-ses-cech-h1` = `ses_cech_h1` (done); (iv)
injective vanishing `Hⁿ(U,I)=0` for `n>0` = `absoluteCohomology_eq_zero_of_injective` (done,
Form B); (v) the covariant LES of `H*(U,-)` = the three `absoluteCohomology_covariant_exact₁/₂/₃`
wrappers (done, Form B); (vi) the per-cover hypothesis `Ȟᵖ(𝒰,F)=0` for `p>0` = P3
standard-cover vanishing. **`affine_serre_vanishing` (02KG) appears nowhere in the 01EO proof
— it is the *conclusion* specialised to affines.** The regress is genuinely broken. The
strategy's `\uses {injective_cech_acyclic, ses_cech_h1, cech_acyclic_affine}` (NOT
`affine_serre_vanishing`) is correct.

### Route: Absolute cohomology realization — Ext of the corepresenting object (Form B)

- **Goal-alignment**: PASS — `Ext^p(jShriekOU U, -)` is the right-derived functor of
  `Hom(jShriekOU U, -) ≅ Γ(U,-)` (via the landed `H⁰≅Γ`), i.e. genuine sheaf cohomology
  `Hᵖ(U,-)`, computed entirely inside `X.Modules`.
- **Mathematical soundness**: PASS — Mathlib `Abelian.Ext` is balanced; the covariant LES and
  `Ext.eq_zero_of_injective` are exactly the two derived facts 01EO's proof manipulates, and
  they sit in the *second* Ext argument, so no restriction of the coefficient sheaf (hence no
  `j_!` functor, no restriction-preserves-injectives) is ever required.
- **Sunk-cost reasoning detected**: no — the retention rationale is on the merits (needs only
  the corepresenting *object*, off-the-shelf LES), and is now corroborated by an axiom-clean
  landing (10 decls, 0 sorries; I re-verified `absoluteCohomology_eq_zero_of_injective`:
  axioms = `propext, Classical.choice, Quot.sound`, kernel-only).
- **Verdict**: SOUND

**Still-live Form-B vs `rightDerived`-global point — RESOLVED in favour of Form B.** The
empirical landing settles feasibility, and the verbatim 01EO proof settles sufficiency: every
fact 01EO consumes is a Form-B deliverable or an already-done brick. The `rightDerived`-global
alternative would need the *same* LES and the *same* injective vanishing but hand-built (no
packaged δ-LES on `Functor.rightDerived`, per the strategy's own note), i.e. strictly more
work for an identical mathematical payload. The challenge does not survive.

## Format compliance

- **Size**: ~125 lines / well under budget — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `Goal, Phases & estimations, Completed, Routes, Open strategic
  questions, Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: no — iter numbers appear only in the `## Completed` ledger's
  `Iters` cells (allowed); no "this iter / last iter / the iter-XYZ pivot" prose.
- **Accumulation detected**: no — completed bricks (P1/P2/P4/P3/P3b-bridge) are in `## Completed`;
  active table holds only ACTIVE/BLOCKED phases; the REJECTED Route B is a live route comparison,
  not excised history.
- **Table discipline**: PASS — both tables carry the canonical columns with one-line cells;
  `## Completed` has 5 rows (within bound).
- **Format verdict**: COMPLIANT

## Open strategic questions (critic input)

**(A) Open question #2 — general vs affine-specialised 01EO: prefer the GENERAL basis criterion.**
The Stacks 01EO is already stated parametrically in `F` and in the per-cover vanishing hypothesis
(condition 3); its proof (read above) uses *no* affine-specific input — affineness enters only when
instantiating `Cov` = standard covers and `B` = distinguished-open basis for 02KG. An
affine-specialised statement would still have to set up `Cov`/`B` and discharge conditions (1)–(3),
so it is barely cheaper, while the general form is reusable for the P5a `Hᵏ(f⁻¹V,G)` comparisons.
Recommend: formalise the general basis criterion, instantiate for 02KG. (Non-blocking — either is
non-circular, as the strategy already notes.)

**(B) Minor unlisted prerequisite of 01EO — naturality of `H⁰≅Γ` in the sheaf argument.** 01EO's
key step "`H⁰(U,I) → H⁰(U,Q)` is surjective because `I(U) → Q(U)` is" (lines 1769–1770) transfers
section-level surjectivity (from `ses_cech_h1`) across the `H⁰≅Γ` iso, which requires that iso to be
*natural* in the second variable — i.e. the square `H⁰(U,g)` vs `g_U : I(U)→Q(U)` commutes. The
landed `absoluteCohomologyZeroAddEquiv` is a bare `AddEquiv` at fixed `F`; naturality is not yet
established. In Ext terms this is "post-composition with `mk₀ g` corresponds under
`jShriekOU_homEquiv` to `g` on sections" — tractable, but a concrete obligation the 01EO objective
should budget rather than discover mid-proof. Recommend the planner list it explicitly as an 01EO
sub-target. (Heads-up, not a strategic flaw.)

## Overall verdict

The strategy is **SOUND** and the document is **COMPLIANT**. The previously-live Form-B challenge
is resolved against the challenger: Form B has landed axiom-clean, and — decisively — the verbatim
Stacks 01EO proof consumes exactly the five Form-B / done-brick facts (injective_cech_acyclic,
ses_cech_h1, injective-vanishing, covariant LES, H⁰≅Γ) and *never* `affine_serre_vanishing`, so the
01EO → 02KG → Route-A acyclicity bridge is genuinely non-circular and the `rightDerived`-global
alternative is strictly more work for identical payload. Two non-blocking refinements for the
planner: (A) prefer the general basis-criterion shape of 01EO over an affine specialisation, and
(B) explicitly budget the naturality of the `H⁰≅Γ` corepresentability iso in the sheaf argument,
which 01EO's surjectivity step silently needs and which the current bare-`AddEquiv` landing does not
yet supply.
