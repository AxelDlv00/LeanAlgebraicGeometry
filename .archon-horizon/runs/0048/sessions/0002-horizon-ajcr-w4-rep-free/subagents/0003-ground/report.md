I've reconstructed the state independently. Here is the verdict.

## Bottom line

You did not relabel a wall — you **converted an unprovable hypothesis into a provably false one**. That is a genuine upgrade, and it is the most valuable thing produced in eight sessions. But it also means the chain you wrote into the roadmap (`chart-avoid → swallow-adapt → cert-collapse → cert-assemble`) is a **dead path with a decision at its head**, not a critical path. Presenting it as the latter is the main thing wrong with this session's output.

Also: you under-reported. You briefed me on two files. There are three. `AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean` (commit `40f357de8`, tip of the ledger) is the consequential one, and it is where the overclaims live. I kernel-checked it myself — `lake env lean` exits 0, clean.

---

## Q1 — Is the lane converging?

**No, and it cannot. But the pivot is still correct.**

Before: discharge `hnoLeak` for `(exists_divisorAdaptation ...).some` — an adaptation about which nothing is known. Nobody could do it.

After: arrange `supportLocus ⊆ V₀ ⊓ V₁`. This is not "just as hard" — it is **strictly harder, because it is false**. Your own counter-model proves it: `V(t x² + x y + t y²) ⊆ ℙ¹` over `k[t]` has section ring `k[t][x]/(tx² + x + t)`, a domain, so it is connected over *every* basic open of `Spec k[t]`, and its fibre at `t = 0` is `{0, ∞}`. No lemma about the DD-R atlas can make that divisor chart-confined.

So `chart-avoid` is a **carve or a redesign, never a lemma**. The roadmap leaf says "lemma, carve, or redesign" as if all three were live. Only two are.

The convergence that *did* happen is of a different kind: three routes are now formally refuted rather than merely stalled (`tube-fibre` via `not_exists_unique_support_piece`, separation via `DivSchemeCertZarSep`, and now refinement-of-the-cover via the partition-of-unity argument). That is real. It is just not progress toward representability.

## Q2 — Is `chart-avoid` true for the DD-R family?

**No. The DD-R chart contains no fibre-avoidance condition anywhere, and the spec forbids adding one.**

Verified across the construction: `ThetaGeneratorSeed` (`AlgebraicJacobian/Picard/DivSchemeFamily.lean:74`) has five fields, and `side : relCurve C R → Bool` merely picks *some* chart containing each point — a point of `π⁻¹(0)` is perfectly legal, it just gets `side = false`. `IsGenerator` adds local divisibility plus fibrewise regularity, nothing else. Same for `relThetaSections`, `FinCoverData`, `DivisorAdaptation`, `IsCertified`, `DivCarveChartRing`, `DivScheme`, `DivSchemeAtlasFactor`. The only occurrences of `π⁻¹(0)` / `π⁻¹(∞)` in the entire Lean tree are five doc-comment lines, in your two new files.

And the spec actively bans the condition. `informal/spec-dd-r.md` §Discipline (2) and §1 ADJUDICATION A:

> **never a support condition `supp D ∩ π⁻¹(Gm) = ∅`** … Any DD-R prover writing a support-separation hypothesis has left the route.

Meanwhile ADDENDUM 1 asserts the universal family "is honestly certified over each `Z(♦)`-chart ring". **No unconditional Lean theorem backs that.** Every landed route to `IsCertified` takes `hnoLeak`, kernel-spanning, or separation as a hypothesis — `isCertified_of_kernel_spanning`, `isCertified_of_noLeak_kernel_spanning`, `DivSchemeCertZarKerSpan.lean:63,123`, `isCertified_of_separated`, and `ThetaGeneratorSeed.certifiedFamily` (`DivSchemeEps.lean:237`) which takes `IsCertified g` as an *input*.

So it is your option (b): the spec and the landed mathematics now contradict each other.

## Q3 — Is `DivFamZar` the right functor?

**No, and I-0213 did *not* already concede this ground — you have proved something strictly stronger.**

`divFunctor` (`AlgebraicJacobian/Picard/DivisorFamilyZarFunctor.lean:45`) unfolds definitionally to `DivFamZar → IsLocallyCertified → CertifiedDivisorFamily → IsCertified`. Nothing pins it to an honest relative effective Cartier divisor. The only bridge to standard mathematics is at **field-valued tests** (`divFamFieldEquiv`, `DivisorFamilyFieldSurj.lean:162`) — and it works there only because over a field every module is projective. Over a general base there is no theorem relating `IsCertified` to a finite flat closed subscheme, and no producer of a certified family from any honest geometric input.

Two further facts you should have in hand: **there is no Lean declaration named `divRep`.** Both packagings — `DivRepGlobalData` (`DivRepKit.lean:68`) and `DivRepAffinePullback` (`DivRepAffKit.lean:167`) — are hypothesis bundles, never instantiated. And the **blueprint says nothing about any of this**: zero hits for `divFunctor`, `divRep`, `DivFamZar`, `IsCertified`, `DivScheme`, `carve` across `blueprint/src`.

On I-0213: it conceded that the **global** certificate misses the diagonal divisor, and its repair — `IsLocallyCertified`, localize the base — *defeats* that counterexample, because the diagonal locally stays in one chart. Your connected counter-model defeats the repair too, because base localization does not disconnect an integral divisor scheme. That is new ground, not conceded ground.

**But it is one lemma short of being formal.** This is the most important thing I found.

`DivSchemeCertZarConn.lean:125` asserts "the certificate interface `IsCertified` — whose per-piece clause (c1) forces leak-freeness". The same step is asserted in roadmap `chart-avoid`, in I-0209 ("(c1) … IFF the piece trace is CLOPEN"), and in I-0327. **No Lean declaration proves it.** The index returns only the three sufficient directions (`finite_colength_of_supportLeak_eq_empty`, `…_of_isClosed_supportLocus_inter`, `…_of_isClopen_trace`). Without the converse, ChartTrace/Swallow/Conn are theorems about *one sufficient-condition assembler*, not about `IsCertified`. With it, they are a design refutation.

It is provable, and cheaply. Filed as I-0334 with the full route; the statement is

```lean
theorem supportLeak_eq_empty_of_finite_colength (j : A.index) [IsProper C.hom]
    (h : Module.Finite R (A.colength j)) : d.supportLeak (A.pieces j) = ∅
```

`colength j = Γ(relCurve C R, A.pieces j) ⧸ span {A.eqn j}`, so `Spec (colength j)` is the closed subscheme of the affine `pieces j` whose underlying set is `supportLocus ∩ pieces j`. `Module.Finite` makes `Spec (colength j) → Spec R` finite, hence universally closed; `relCurve C R → Spec R` is separated (the properness licence is already in scope); so the map to `relCurve C R` is closed and the image is closed. Standard, no new geometry.

## Q4 — Allocation, ranked

**No, continuing to spend rounds on the certificate is not the right allocation** — except for one round, to finish the refutation.

1. **Prove I-0334's lemma** (~1 session). It is the only thing that turns eight sessions of work into a decidable verdict instead of a suggestive one. Everything else in the lane is worth nothing until this lands.
2. **Compose it with `supportLocus_subset_chart_of_isPreconnected` and stop.** That yields `IsCertified n + IsPreconnected supportLocus ⇒ supp ⊆ V₀ ∨ supp ⊆ V₁` with no leak hypothesis, i.e. a formal proof that `DivFamZar` is a proper subfunctor. Then take it to the human. Do not open `swallow-adapt` or `cert-collapse`.
3. **`AJCR.w4-rep.build-reach`** (cheap, high value). I recomputed it: 611 modules, 516 reachable, **95 unreachable**. Two of them are cited by your own certificate roadmap as landed inputs — `DivSchemeSeedUnivPulledDegree.lean:354` (`cert-assemble` calls its `hdeg` "ALREADY PROVED") and `EntryIdeal.lean`. Those citations point at code the default build never checks.
4. **`dat-c.c9-chartlocus`**, off the certificate path entirely. `chartLocus` has zero code hits tree-wide; it gates `dat-b` B-6 *and* the whole `dat-glue` assembly. (Its roadmap anchor is wrong — see Q5.)
5. **`Pic0PreservesFilteredBaseColimit`** (`PicRepColimitCompat.lean:136`) — explicitly divRep-free, reduction landed, nothing blocks it, and it has no roadmap row of its own.

**Honest assessment of "close representability of Pic⁰": not achievable, not close, and the task is mis-scoped.** `Challenge.lean` has 15 real sorries including the target at line 99. `dat-g` has no spec, no worksheet, no Lean file, no blueprint node, and no producer on either side of its handoff struct — I confirmed every sibling has a worksheet and `dat-g` does not. `dat-b` and `dat-c` between them are missing six planned files that do not exist. The blueprint covers none of the divisor layer. Even a miracle on the certificate leaves five mountains.

**Tell the human it needs a redesign decision.** The specific question to put to them: *the spec forbids support conditions, and the landed mathematics proves the certificate is unsatisfiable without one — do we carve the atlas, weaken `IsCertified`, or re-scope the task?* That is a scope decision about their project, not a proof obligation you can discharge.

## Q5 — What you got wrong

- **Dangling reference.** `DivSchemeCertZarChartTrace.lean:35` cites `DivSchemeCertZarChartPair.lean` as realizing the sufficiency direction. **That file does not exist** anywhere in the workspace. Worse, the claim is not obviously true: pieces = `V₀, V₁` requires an adaptation whose `eqn_rel` field (`DivisorFamily.lean:241`) supplies a *single* section of `Γ(relCurve, V_b)` agreeing with `d` up to a unit — principality on the whole chart, which is essentially `swallow-adapt` step (b).
- **The new chain will not compose as written.** `chart-avoid` states its goal as `supportLocus ⊆ V₀` (or the `V₁` twin). `swallow-adapt` consumes swallow-or-miss at every piece, which by your own dichotomies requires `supp ⊆ V₀ ⊓ V₁` *or* `supp` inside a single fibre. "Confined to one chart" is not sufficient: if `supp ⊆ V₀` but `supp` meets `π⁻¹(0)`, no chart-1 piece can swallow it, so all must miss it, forcing `supp ∩ V₁ = ∅`. The Swallow docstring gets this right; the roadmap leaf title and goal do not.
- **Conn's headline theorem is weaker than what you landed one file earlier.** `supportLocus_subset_chart_of_isPreconnected` proves the two-case disjunction; the Swallow dichotomies already give the sharp four-case split. The sharp version is the one `chart-avoid` needs.
- **Roadmap anchor is wrong.** `dat-c.c9-chartlocus` says `chartLocus` is referenced at `Pic0SigmaSheaf.lean:162-164`. That string does not occur in that file at all; lines 155-170 are `pic0RepresentableByOfCharts`. The conclusion is right, the pointer will cost the next session a round.
- **Uncommitted source in the working tree.** `AlgebraicJacobian/Picard/DivSchemeCertZarLeak.lean` is modified and not committed (+26/-4): a namespace refactor moving `section Idempotent` to the root namespace, plus two new theorems (`supportLeak_eq_empty_iff_isClosed_trace`, `isOpen_trace`). Three committed files import it. It compiles — but under one-shot discipline it will be lost.
- **Concurrency hazard worth knowing.** One `lake env lean` run on that file produced a burst of `failed to synthesize Module R Γ(relCurve C R, A.pieces j)` errors at lines 290-296 that did not reproduce on two subsequent runs. Run 0046 is live and rebuilding oleans. Phantom failures — and phantom *successes* — are both possible while another run holds the build directory. Re-verify before pinning any "kernel-checked" claim.

Not wrong, but worth stating: the certificate lane is ~4,400 lines, about 4% of `Picard/`. The allocation problem is not that you spent too much on it in absolute terms; it is that eight sessions went into proving hypotheses of an interface whose satisfiability was never checked. Your own roadmap says exactly that. Believe it.

## Filed

- **I-0334** (issue) — the missing keystone `(c1) ⇒ leak-free`, with the statement and full proof route.
- **I-0335** (issue) — the dangling `ChartPair` reference, the chart-avoid/swallow-adapt mismatch, the wrong `c9-chartlocus` anchor.
- **I-0336** (issue) — uncommitted `DivSchemeCertZarLeak.lean`, the concurrency hazard, and the two unreachable modules cited as landed inputs.
- **I-0337** (memory) — the durable design verdict: `DivFamZar` is not the divisor functor and the I-0213 repair does not save it.

One housekeeping note: the inbox is now at 36 open non-protection items against a recommended 30 (my four contributed), with 33 unread. That is a `janitor` trigger, and I am read-only on it.
