# Strategy Audit — foundation
**Auditor:** strategy-auditor | **Iter:** 001 | **Slug:** foundation

Sources read:
- `references/stacks-coherent.tex` (8138 lines, Stacks Project ch. 30 "Cohomology of Schemes", retrieved 2026-05-20)
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
- `.archon/STRATEGY.md`
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`

---

## Q1 — Tag 02KE: Does the source use one spectral sequence or two?

**Short answer: ONE spectral sequence for 02KE itself; the Leray SS appears only in a
SEPARATE subsequent lemma.**

### Verbatim proof of `lemma-cech-cohomology-quasi-coherent` (Tag 02KE, lines 258–264 of stacks-coherent.tex)

```
\begin{proof}
In view of
Lemma \ref{lemma-quasi-coherent-affine-cohomology-zero}
this is a special case of
Cohomology, Lemma
\ref{cohomology-lemma-cech-spectral-sequence-application}.
\end{proof}
```

That is the **entire proof** of 02KE in Stacks. It cites:
- `lemma-quasi-coherent-affine-cohomology-zero` (Serre vanishing) as the acyclicity input.
- `cohomology-lemma-cech-spectral-sequence-application` (the Čech-to-derived SS application
  lemma from the Cohomology chapter) as the single vehicle.

**No Leray spectral sequence appears in the proof of 02KE.**

### Verbatim proof of `lemma-quasi-coherence-higher-direct-images-application`
(lines 856–868 of stacks-coherent.tex — the affine-base global-sections corollary)

```
\begin{proof}
Consider the Leray spectral sequence $E_2^{p, q} = H^p(S, R^qf_*\mathcal{F})$
converging to $H^{p + q}(X, \mathcal{F})$, see
Cohomology, Lemma \ref{cohomology-lemma-Leray}.
By Lemma \ref{lemma-quasi-coherence-higher-direct-images}
we see that the sheaves $R^qf_*\mathcal{F}$ are quasi-coherent.
By Lemma \ref{lemma-quasi-coherent-affine-cohomology-zero}
we see that $E_2^{p, q} = 0$ when $p > 0$.
Hence the spectral sequence degenerates at $E_2$ and we win.
See also
Cohomology, Lemma \ref{cohomology-lemma-apply-Leray} (2)
for the general principle.
\end{proof}
```

This Leray SS argument is for a **separate lemma** (the affine-base global-sections
corollary `H^q(X,F) = H^0(S, R^q f_*F)`), not for 02KE.

### Diagnosis for the blueprint

The blueprint's `lem:cech_computes_cohomology` proof (and the Lean docstring for
`cech_computes_higherDirectImage`) presents a MERGED proof that chains both spectral
sequences into a single argument:
1. Čech-to-cohomology SS → `Č^p(𝒰, F) = H^p(X, F)` (this is 02KE)
2. Leray SS → `H^q(X, F) = H^0(S, R^q f_* F)` (this is the separate
   `lemma-quasi-coherence-higher-direct-images-application`)
3. Conclusion: `H^i(Č•) ≅ R^i f_* F`

This merged strategy is mathematically correct (and the final lemma in Lean covers both
parts), but **it overstates what 02KE itself requires**. The STRATEGY.md description
"comparison theorem via TWO spectral sequences (Čech-to-cohomology + Leray)" is
technically correct for the full combined statement but misleading about the proof
structure: the two SSes belong to two logically distinct lemmas that Stacks keeps
separate, and only the Čech SS is needed to get the sheaf-level comparison
`Č^p = H^p(X, -)`, while the Leray SS is needed only to further equate `H^p(X,F)` with
`H^0(S, R^p f_* F)` when S is affine. If the latter affine-base corollary were split off
into its own lemma (mirroring Stacks), Phase 3 could be decomposed cleanly.

---

## Q2 — Is there a route avoiding spectral sequences for the sheaf-level comparison?

**Yes. A resolution-based route via `cohomology-lemma-cech-vanish-basis` avoids the
Čech SS for the `Č^p(𝒰,F) = H^p(X,F)` half.**

### What `cohomology-lemma-cech-vanish-basis` says (line 159 of stacks-coherent.tex)

Stacks' Serre vanishing proof (`lemma-quasi-coherent-affine-cohomology-zero`, lines
157–174) already uses this route:

```
\begin{proof}
We are going to apply
Cohomology, Lemma \ref{cohomology-lemma-cech-vanish-basis}.
As our basis $\mathcal{B}$ for the topology of $X$ we are going to use
the affine opens of $X$.
As our set $\text{Cov}$ of open coverings we are going to use the standard
open coverings of affine opens of $X$.
Note that the intersection of standard opens in an affine is
another standard open. Hence property (1) holds.
The coverings form a cofinal system of open coverings of any element
of $\mathcal{B}$, see
Schemes, Lemma \ref{schemes-lemma-standard-open}.
Hence (2) holds.
Finally, condition (3) of the lemma follows from
Lemma \ref{lemma-cech-cohomology-quasi-coherent-trivial}.
\end{proof}
```

`cohomology-lemma-cech-vanish-basis` is the "basis-Čech comparison" lemma: if F has
vanishing Čech cohomology on a basis of the topology (for a cofinal system of covers),
then sheaf cohomology equals Čech cohomology for the whole space. This is NOT a full
spectral-sequence argument — it is a direct basis-comparison using acyclicity, the
sheafy analogue of the augmented-complex-is-exact argument.

### Lighter route for 02KE

The route:

1. Standard-cover Čech vanishing (`lemma-cech-cohomology-quasi-coherent-trivial`, prime-
   local homotopy) — purely algebraic.
2. Basis-Čech comparison (`cohomology-lemma-cech-vanish-basis`) applied with B = affine
   opens, Cov = standard covers → Serre vanishing `H^p(U, F) = 0` for affine U and p > 0.
3. Apply `cohomology-lemma-cech-vanish-basis` again at the scheme level, using the affine
   cover 𝒰 (all intersections are affine, each is acyclic by step 2) →
   `Č^p(𝒰, F) = H^p(X, F)`.

Steps 1–3 avoid the full Čech-to-derived SS. The "spectral sequence" in the Stacks proof
of 02KE (`cohomology-lemma-cech-spectral-sequence-application`) IS essentially
`cohomology-lemma-cech-vanish-basis` under the hood (the basis-comparison is the key
lemma that the SS application invokes), but the SS adds overhead.

**Ingredients needed for the lighter route:**
- `lemma-cech-cohomology-quasi-coherent-trivial` (already in blueprint as `lem:cech_acyclic_affine`).
- `cohomology-lemma-cech-vanish-basis` from the Cohomology chapter (NOT in stacks-coherent.tex;
  currently absent from Mathlib for `Scheme.Modules`).
- The same Leray SS is still needed for the affine-base corollary
  `H^q(X,F) = H^0(S, R^qf_*F)` (if that is to be included in the statement).

**Verdict:** The lighter route replaces one absent Mathlib ingredient
(`cohomology-lemma-cech-spectral-sequence-application`) with a conceptually simpler but
equally absent one (`cohomology-lemma-cech-vanish-basis`). Since neither is currently
in Mathlib for `Scheme.Modules`, the practical bottleneck is the same. However, the
basis-comparison lemma is structurally simpler to develop from scratch (no SS machinery),
so this route may be the better implementation target. The STRATEGY.md should flag this
alternative.

---

## Q3 — Tag 02KG + `lemma-cech-cohomology-quasi-coherent-trivial`: blueprint fidelity

### Stacks structure (two distinct lemmas, lines 44–174)

**Lemma 1 — `lemma-cech-cohomology-quasi-coherent-trivial`** (lines 44–135):
Standard-cover Čech vanishing. Statement: for an affine U = Spec(A) with standard cover
U = ∪ D(f_i) and any quasi-coherent F, Č^p(𝒰,F) = 0 for all p > 0.

Proof: Write F|_U = M̃. The Čech complex is identified with localisations
`∏ M_{f_{i₀}} → ∏ M_{f_{i₀}f_{i₁}} → ...`. Exactness of the augmented complex
`0 → M → ∏ M_{f_{i₀}} → ...` is checked after localising at a prime p;
choose i_fix with f_{i_fix} ∉ p; define the contracting homotopy
`h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}`; compute `(dh + hd)(s) = s`.
References: `algebra-lemma-cover-module` (the algebraic truncation) and
`algebra-lemma-characterize-zero-local` (exactness via prime-localisation).

**Lemma 2 — `lemma-quasi-coherent-affine-cohomology-zero`** (Tag 02KG, lines 145–174):
Serre vanishing. Statement: for any scheme X, any quasi-coherent F, and any affine open
U ⊂ X, H^p(U,F) = 0 for all p > 0.

Proof: Apply `cohomology-lemma-cech-vanish-basis` with B = affine opens, Cov = standard
covers. Condition (3) = `lemma-cech-cohomology-quasi-coherent-trivial`. The Serre
vanishing is a DERIVED CONSEQUENCE of the standard-cover Čech vanishing via the
basis-comparison lemma.

### Blueprint's `lem:cech_acyclic_affine` — assessment

The blueprint's `lem:cech_acyclic_affine` **conflates both Stacks lemmas into a single
statement**: it claims both `Č^p(𝒰,F) = 0 for p > 0` (= Lemma 1) AND `H^p(U,F) = 0
for p > 0` (= Lemma 2, Tag 02KG). The proof faithfully reproduces:

- Part 1: the prime-local contracting homotopy `h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}`,
  citing `algebra-lemma-cover-module` and `algebra-lemma-characterize-zero-local`. ✓
- Part 2: the `cohomology-lemma-cech-vanish-basis` application for Serre vanishing. ✓

**Is there a circular dependency?** No circularity. The logical flow is:
```
lemma-cech-cohomology-quasi-coherent-trivial  (prime homotopy, purely algebraic)
           ↓ (via cohomology-lemma-cech-vanish-basis)
lemma-quasi-coherent-affine-cohomology-zero   (Serre vanishing)
           ↓
lemma-quasi-coherence-higher-direct-images-application (Leray SS + Serre)
           ↓
lem:cech_computes_cohomology
```

The Čech SS application (for 02KE) sits between the first two steps:
```
lemma-cech-cohomology-quasi-coherent-trivial + lemma-quasi-coherent-affine-cohomology-zero
           → cohomology-lemma-cech-spectral-sequence-application
           → lemma-cech-cohomology-quasi-coherent (02KE)
```

**Concern about conflation:** The blueprint proves Serre vanishing (`H^p(U,F) = 0`) as
the SECOND half of `lem:cech_acyclic_affine`, but the Lean theorem
`CechAcyclic.affine` only proves the Čech complex vanishing (`IsZero ((CechComplex f
𝒰 F).homology p)`), not the sheaf-cohomology statement. The blueprint's prose does
more than the Lean signature commits to. This is not dangerous, but:
- If the Lean proof of `cech_computes_higherDirectImage` needs SERRE VANISHING (`H^p(X,F)=0`
  for p > 0 on affines), it must derive this separately, since `CechAcyclic.affine` only
  gives Čech-complex vanishing, not sheaf-cohomology vanishing.
- The blueprint's `\uses{def:cech_complex}` for `lem:cech_acyclic_affine` omits
  `cohomology-lemma-cech-vanish-basis` as a dependency of the Serre vanishing half.

**Recommendation:** Separate the blueprint's `lem:cech_acyclic_affine` into two lemmas
matching Stacks exactly: (a) standard-cover Čech vanishing (the homotopy); (b) Serre
vanishing derived from (a). This matches the Lean signature better and makes the
dependency on `cohomology-lemma-cech-vanish-basis` explicit.

---

## Q4 — Missing prerequisites, unnecessary case splits, hallucinated routes

### Missing prerequisites

1. **`cohomology-lemma-cech-spectral-sequence-application`** — The key tool for
   Tag 02KE. This is in the Stacks "Cohomology" chapter (not stacks-coherent.tex).
   The strategy correctly identifies it as absent from Mathlib for `Scheme.Modules`;
   no structural error, but the STRATEGY.md should clarify that only THIS single
   lemma is the obstacle for the sheaf-level comparison (not "two SSes").

2. **`cohomology-lemma-cech-vanish-basis`** — Needed for Serre vanishing. Also from
   the Cohomology chapter, also absent from Mathlib for `Scheme.Modules`. This is the
   lighter alternative route and should be named explicitly in the strategy.

3. **`lemma-quasi-coherence-higher-direct-images`** (lines 741–841 of stacks-coherent.tex)
   — This lemma establishes that `R^p f_* F` is quasi-coherent for quasi-compact
   quasi-separated f. It is a NON-TRIVIAL prerequisite for the Leray SS argument in
   `lemma-quasi-coherence-higher-direct-images-application`: the Leray SS degenerates
   because `R^q f_* F` is quasi-coherent (so Serre vanishing applies on affine S).
   The blueprint's `\uses{}` for `lem:cech_computes_cohomology` does NOT list this
   quasi-coherence fact. The Lean comment in `cech_computes_higherDirectImage` also
   omits it. **This is a missing prerequisite.** The proof that `R^q f_* F` is
   quasi-coherent itself uses an induction principle + relative Mayer-Vietoris (lines
   776–803 of stacks-coherent.tex) — that argument is non-trivial and would need to
   be in Mathlib or proved in-project.

4. **`algebra-lemma-cover-module`** and **`algebra-lemma-characterize-zero-local`** —
   Referenced in the standard-cover Čech vanishing proof. These are algebraic lemmas
   from the Algebra chapter of Stacks; they say (a) the truncated Koszul complex is
   studied in Algebra, and (b) exactness can be checked prime-locally. Both should
   exist in Mathlib (`Module.isZero_iff_forall_localization` type results), but the
   exact Mathlib names should be verified before assigning the prover.

### Unnecessary case splits

None identified. The source does not split into cases (e.g., separated vs. non-separated)
for the proof of 02KE or 02KG; it handles everything in the separated/affine-diagonal
setting uniformly, which is exactly what the blueprint does.

### Hallucinated routes

1. **STRATEGY.md: "comparison theorem via TWO spectral sequences (Čech-to-cohomology +
   Leray) for Scheme.Modules".** This is not hallucinated (both SSes are used in the
   combined proof), but it mischaracterizes the proof structure: 02KE itself uses only
   the Čech SS, and the Leray SS belongs to a separate downstream lemma. The STRATEGY.md
   should read: "the sheaf-level comparison (02KE) via `cohomology-lemma-cech-spectral-
   sequence-application` (one Čech SS) + the affine-base global-sections corollary
   via the Leray SS."

2. **Blueprint push-pull functor paragraph (3) "coherence-free plumbing":** The claim
   that passing from the nerve to the cochain complex "uses no pushforward/pullback
   coherence" is accurate for the plumbing step. Not hallucinated.

3. **Blueprint §2 push-pull functor (2):** The claim that the functor G uses "the mate
   identity expressing the conjugate of the inverse pullback comparison as the pushforward
   comparison" is accurate. Not hallucinated.

---

## Summary of corrections needed

### STRATEGY.md

| Location | Issue | Correction |
|---|---|---|
| Phase 3 "comparison theorem" | Says "TWO spectral sequences (Čech-to-cohomology + Leray)" — conflates what Stacks does in two separate lemmas | Split: (a) `Č^p(𝒰,F) = H^p(X,F)` via ONE Čech SS (02KE, `cohomology-lemma-cech-spectral-sequence-application`); (b) `H^q(X,F) = H^0(S, R^qf_*F)` via ONE Leray SS (separate lemma). Flag both as absent from Mathlib. |
| Phase 3 "comparison theorem" | Missing prerequisite: quasi-coherence of `R^q f_* F` | Add: the proof requires `lemma-quasi-coherence-higher-direct-images` (Stacks lines 741–841) — that R^p f_* F is quasi-coherent for QC QS f. This itself needs induction-principle + relative Mayer-Vietoris. Add to prerequisite list. |
| Phase 3 "Risks" | No mention of lighter route | Add alternative: the Čech SS step can potentially be replaced by `cohomology-lemma-cech-vanish-basis` (basis-comparison), which avoids full SS machinery. Lighter to develop from scratch if absent from Mathlib. |
| Phase 2 "affine acyclicity" | `lem:cech_acyclic_affine` conflates Čech vanishing + Serre vanishing | Note that the Lean theorem only proves Čech-complex vanishing; Serre vanishing (for the proof of `cech_computes_higherDirectImage`) must be derived separately via `cohomology-lemma-cech-vanish-basis`. |

### Blueprint

| Location | Issue | Correction |
|---|---|---|
| `lem:cech_acyclic_affine` `\uses{}` | Missing `cohomology-lemma-cech-vanish-basis` dependency for the Serre vanishing half | Add or document as a Cohomology-chapter cross-dependency |
| `lem:cech_computes_cohomology` `\uses{}` | Missing quasi-coherence of `R^q f_* F` (= `lemma-quasi-coherence-higher-direct-images`) as a prerequisite | Add `lem:rqf_quasicoherent` (or equivalent) to `\uses{}` |
| `lem:cech_computes_cohomology` proof note | Currently-absent infrastructure note says "two spectral sequences" | Correct to: "one Čech SS (`cohomology-lemma-cech-spectral-sequence-application`) for the main comparison plus one Leray SS for the affine-base corollary; or alternatively, `cohomology-lemma-cech-vanish-basis` in place of the Čech SS" |

---

## Verdict

**STRATEGY.md is structurally sound but has two consequential inaccuracies:**

1. **Two-SS claim is misleading:** Tag 02KE requires only ONE spectral sequence (the Čech
   SS via `cohomology-lemma-cech-spectral-sequence-application`); the Leray SS is for a
   separate lemma. The combined statement in Lean does need both, but the strategy should
   model them as two sub-steps, not a single monolithic "two-SS" step.

2. **Missing prerequisite — quasi-coherence of `R^q f_* F`:** The Leray SS argument
   degenerates only because `R^q f_* F` is quasi-coherent; establishing this requires
   `lemma-quasi-coherence-higher-direct-images` (a non-trivial lemma using induction +
   Mayer-Vietoris), which is absent from the blueprint's dependency graph.

No hallucinated routes and no unnecessary case splits were found. The push-pull functor
route is faithful to the source. The affine acyclicity proof faithfully reproduces the
prime-local contracting homotopy of `lemma-cech-cohomology-quasi-coherent-trivial`.

Report path: `.archon/task_results/strategy-auditor-foundation.md`
