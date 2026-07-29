Three items filed (I-0786, I-0787, I-0788). Verdict below.

## Verdict: CONVERGING, with one real gap — the reduction is true but homeless

Not churn, not a sorry-stall dressed up. The five declarations are load-bearing and the headline claim survives adversarial testing. But the round's actual deliverable — the chain that makes the claim true — was never committed.

## (a) Verified independently: PASSES

`lake build AlgebraicJacobian.Cohomology.CechHigherDirectImageUnconditional` → 3243 jobs, EXIT=0. Sorries exactly at `:924`, `:2743`, `:2919` — unchanged. All five declarations report `[propext, Classical.choice, Quot.sound]`; controls `twisted_cech_nerve_iso` and `cech_flatBaseChange_oneLeaf` still report `sorryAx`, so no endpoint moved, as claimed.

## (b) THE CLAIM YOU MOST WANTED ATTACKED: it holds — I could not break it

I ran `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/probe_fbc9.lean` myself. **Zero errors.** The residual goal of `BcSquareCounitSide` contains `bcv` 0 times, `openImmersion_bareBC` 0 times, `mateEquiv` 0 times, `hF` 0 times. What survives: `ppTel` x2, `pullbackComp` x4, `pullbackCongr` x2, `openImmersion_bc_telescope` x2, two counits *of the open inclusions* `ι U_σ`, and one `pushPullMap F (interLegHom 𝒰 σ' k)`. So the five lemmas do reach `BcSquareCounitSide`, and it is a reduction, not a re-expression.

Two qualifications on the docstrings, neither fatal:

- The chain is **6 non-obvious steps**, and plain `rw [rawPushPullMap_pullback_counit]` **does not fire** in the real goal. I tried it: "did not find an occurrence" plus an application type mismatch between `(Over.mk pV).hom` and `Limits.pullback g' (ι U_σ)`. Only `erw` with the lemma hand-instantiated at `Over.Hom.left (wmap …)` / `Over.w (wmap …)` works, and the last step needs `(ppTel …).inv.naturality (bcv … τ).hom` + `Functor.comp_map` + `slice_lhs`. The docstrings read as "one rewrite away". They are not.
- The surviving `pushPullMap F (interLegHom 𝒰 σ' k)` is itself a `rawPushPullMap` at the X-level opens, still carrying its own unit. It is not the same species as the coherence isos around it, and no r6 lemma has touched it.

**The real problem: `probe_fbc9.lean` is gitignored** (`.gitignore:46`), written at 09:57, ten minutes after the last commit at 09:47. Nothing in the module records the chain. A future session sees five lemmas and a docstring assertion, and must rediscover all six steps including the `rw`-fails-`erw`-works trap. This is where "converging" is at risk: the bricks landed, the reduction did not.

## (c) Docstrings vs. what is proved

`bcv_hom_eq` really is `rfl` (`:4485`). `bcv_pullback_counit`'s RHS genuinely contains no mate — confirmed both in the statement and in the probe's residue. "No flatness, no quasi-coherence" checks out: `hF` appears 0 times in the residue.

One overstatement: "no **open-immersion property** is left in it" (`:4506`). The residue's two surviving counits are the counits of `pullbackPushforwardAdjunction (ι (coverInterOpen 𝒰 σ))`, and `openImmersion_bc_telescope` appears twice with the open inclusions as arguments. The open immersions have not left the statement; what left is any *use* of an open-immersion **lemma**. Narrower claim than the sentence makes.

## (d) Stale prose in the file: four sites (this is the recurring failure mode here)

The commit says the "nothing relates the mate across a change of square" frontier "is now gone". It did not retract it where the file asserts it:

- `:4060` — `BcSquareNaturality`'s own docstring still says "nothing in the tree relates the mate across a change of square". Highest-value one: this is the docstring a session pricing the leaf reads.
- `:3552` — same sentence, present tense.
- `:4042` — "measured at r5", says half (a) is about `openImmersion_bareBC` **and** the telescope; the `bareBC` half is now discharged.
- `:4225–4238` — `bareBC_pullback_counit`'s "**That is the honest frontier**" note describes exactly the residue r6 closed, and reads as open. `:4048`/`:4216` still list the `mateEquiv_vcomp` route as a live candidate blocked on a brick nothing now needs.

The r6 section is appended at `:4290`, the end of the file; the header's "Obligations not yet discharged" (`:98–157`) and the whole half-(a) section were untouched. The file now says both "the mate is the frontier" and "the mate is gone", in different places — the same pattern its own `:19` and `:2085` notes retract from earlier rounds.

## Filed

- **I-0786** (issue) — residue is real but lives only in a gitignored probe; promote the chain to a named lemma.
- **I-0787** (issue) — the four stale prose sites, with line numbers.
- **I-0788** (memory) — "The bricks can be true and the CHAIN still uncommitted": if the headline is "X reduces to Y", the deliverable is a named lemma whose statement is Y. Test: would deleting every scratch file leave the claim reproducible from the module alone?

Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/probe_fbc9.lean` (gitignored — the chain worth promoting is lines 17–44).
