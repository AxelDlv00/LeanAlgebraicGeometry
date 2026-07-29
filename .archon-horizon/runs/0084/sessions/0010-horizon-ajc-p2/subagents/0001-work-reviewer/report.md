Both items filed (issue I-1312, plus the memory). Here is my report.

## Verdict: real but smaller than advertised — one genuine theorem, over-framed; two of six declarations are restatements

The work is **not** stuck and **not** faking: the build is green, axioms are clean, and §2 is a true, non-vacuous theorem. But the file's headline contribution is materially smaller than the module docstring says, and the specific thing you asked me to look hardest for — that you proved by hand something the library gives — is **half true in a way your own probes structurally could not detect**.

Freshness: `lake build AlgebraicJacobian.Picard.PicEtDescentAssembly` **EXIT=0, 8684 jobs**, re-run twice because a concurrent lane deleted `Albanese/CodimOneExtension.olean` and `FGAPicRepresentability.olean` mid-audit. Note the file at HEAD is now `77914d6630`, 333 lines, six decls — `picEtRestrictEquiv_of_surjective` was deleted at `dd225859d8`, so your item 4 asked about a declaration that no longer exists.

### 1. Vacuity — your claim stands, your probe did not

`Subsingleton` failing `infer_instance` is the weak form (failing synthesis is not absence). The right control is dropping `h`: `/tmp/wrprobe/p9.lean`, `EXIT=1`, `aesop` reporting no progress. Also `Nonempty ((picEt C).obj (op T))` is *provable* via the group zero (`/tmp/wrprobe/pJ.lean`, EXIT=0), so the class type is inhabited; and `coverMap` is neither `IsIso` nor `IsSplitEpi` by synthesis. At `k' = k` the theorem still applies and still says something. Conclusion right, reasoning replaced.

### 2. Renaming — CONFIRMED, and your framing is too generous

`existsUnique_amalgamation_picEt_fieldCover` is `Scheme.isSheafFor_picEt_pullback_presieve` (`EtaleFieldCover.lean:308`, ajc-p1, `635b38ab21`, the previous night). `/tmp/wrprobe/p2.lean`, **EXIT=0**, two ways: the two *propositions* are equal by `rfl`, and the two *terms* are equal by `rfl`. It also falls out of the arbitrary-sieve `isSheafFor_picEt_of_mem` in one application. Your defence — "the value is the pricing consequence" — is the right category, but `EtaleFieldCover.lean:289` already said "a family … has a *unique* amalgamation" and `:294` already said "every covering sieve, `⊤` included, for free from sheafification". The pricing was in the tree; what was new is that a lane read it. Worth a line, not a declaration.

### 3. Derivability — REFUTED as you stated it, CONFIRMED in a sharper form

The sheaf axiom does **not** hand you §2 (your two EXIT=1 probes reproduce). But §2's content is a **sieve equality with no geometry in it at all**:

```
((Sieve.overEquiv T).symm (Sieve.generate (Presieve.singleton (pullback.fst T.hom φ))))
  = Sieve.generate (Presieve.singleton (Over.homMk (pullback.fst T.hom φ) pullback.condition))
```

I transcribed your proof into an arbitrary category with pullbacks, arbitrary base object, arbitrary `φ`, arbitrary presheaf `P` — no `Scheme`, `Field`, `Algebra`, étaleness or `picEt` — and both the equality and the injectivity consequence close: `/tmp/wrprobe/pM.lean`, **EXIT=0**. Given that lemma, §2 is five lines: `/tmp/wrprobe/pL.lean`, **EXIT=0**.

This is the finding that matters. Your docstring paragraph "That the factorisation is not avoidable is measured, not assumed" is *true* and *misused*: an unavoidability probe varies the tactic and holds the statement fixed, so it can never see that the statement belongs in a `Sites` file under no hypotheses. The paragraph reads as a defence of the lemma's specificity, which it does not establish.

### 4. Dead binders — your claim stands

`[FiniteDimensional k k']` and `[Algebra.IsSeparable k k']` are both load-bearing: dropping each fails to synthesize `Module.Finite` / `Algebra.IsSeparable` (`/tmp/wrprobe/p4.lean`, `p5.lean`, both `EXIT=1`). But per finding 3 they are load-bearing only to *name the covering-sieve witness in your chosen route*, not to the reduction — so this is not evidence of geometric content. `SmoothOfRelativeDimension`/`IsProper` are structural to `picEt` existing at all. Axioms `[propext, Classical.choice, Quot.sound]` against `fgaPicardRepresentability` firing `sorryAx`.

### 5. Claims vs. statements — one CONFIRMED overstatement, one claim vindicated

The module docstring's reason for the file to exist is that nothing states "the step that takes a representation over a larger field and returns one over `k`". **No declaration in the file has that shape.** The closest, `representableByRestrict_of_baseChange`, concludes `((restrictTest k k').op ⋙ picEt C).RepresentableBy X'` with `X'` a **k'-object** — a restricted functor represented over `k'`, not a `k`-scheme representing `picEt C` (`/tmp/wrprobe/pK.lean`). So the census is accurate and the remedy was not applied, while `FGAPicRepresentability.lean:479-496` now tells readers it was.

Vindicated: §4's "`LocallyOfFiniteType` descends along exactly this cover" checks out. Mathlib's instance needs `Surjective ⊓ Flat ⊓ QuasiCompact`; all three hold for this cover (`/tmp/wrprobe/pO.lean`, EXIT=0), and the bare `DescendsAlong @LocallyOfFiniteType @Surjective` does **not** synthesize — so "exactly this cover" is the correct qualifier, not hedging.

### What to do

1. Lift the sieve equality to a hypothesis-free lemma over an arbitrary `Over`-category and restate §2 as its instantiation. About 20 lines, and it retires the pretence that the reduction is Picard-specific.
2. Delete `existsUnique_amalgamation_picEt_fieldCover` or label it a `rfl`-restatement at its declaration, and fix `FGAPicRepresentability.lean:492`, which cites it as a result.
3. Stop describing the file as supplying the missing goal until some declaration concludes over `k`.

Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentAssembly.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/EtaleFieldCover.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean`. Probes kept under `/tmp/wrprobe/`. Filed: inbox `issue` **I-1312**, plus a `memory` on unavoidable-vs-geometric. I edited no Lean source.
