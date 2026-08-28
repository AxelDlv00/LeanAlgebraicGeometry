Both updates confirmed applied and honest. Here's everything on the other claims.

## Claim 4 — the uniform-bound hypothesis: NOT too strong, and the theorem is more interesting than you argued

`hle : ∀ z, ringKrullDim (stalk z) ≤ g` does **not** nearly imply the conclusion. It gives `≤` and nothing else; the `≥` direction comes from an independent source (the tangent computation at `e`). The theorem is a genuine two-sided assembly.

One thing you got wrong in the *other* direction, and it strengthens you: `((0:ℕ) : WithBot ℕ∞) ≤ (⊥ : WithBot ℕ∞)` is **false** (machine-checked). So the `≥` half, even at genus 0, implicitly asserts `Pic⁰` is nonempty — `hle` alone cannot give that, since an empty scheme satisfies `hle` vacuously and has dimension `⊥`. Your `≥` half carries content that `hle` provably cannot supply. Worth saying in the docstring; right now it reads as though `≥` were the cheap half.

Also on your question about `WithBot ℕ∞` making the inequality trivial: it cannot go the other way either. `⊤` on the RHS would make it trivial, but nothing in the statement forces `topologicalKrullDim` to `⊤`, and the `≤` half rules it out whenever `hle` holds with `g : ℕ`.

## Claim 5 — retraction CORRECT, both halves

The dimension-0 argument holds: mathlib makes `genericPoint` the `OrderTop` of an integral scheme's specialization order (`x ≤ genericPoint X := le_top`, verified), `coheight` of a maximal element is 0, and `ringKrullDim_stalk_eq_coheight` converts. So `∀ z, ringKrullDim (stalk z) = d` forces `d = 0` on any nonempty scheme with a generic point. The warnings at `SchemeKrullDimStalk.lean:96-110` and `:176-183` say exactly this.

The transitivity statement is also correct as written: translation by a group's `k`-points acts transitively on `k̄`-points over an algebraically closed field, not on scheme points (generic points are not in the orbit of a closed point — they have different residue fields). Your original "translation makes all stalks isomorphic" was false for precisely that reason.

## Claim 6 — grep correct, scope incomplete, and a janitor caught the gap

`topologicalKrullDim` is named nowhere in `Jacobian.lean` (verified). Its leaf-B docstrings at `Jacobian.lean:437-460` price the Kähler-rank translation, which is a different obligation and untouched. That part of your claim holds.

But the retracted paragraph *was* standing at a second site you didn't check: `hgraph/nodes/40f8673046ce.md` carried the entire superseded pricing verbatim, because the node is generated from the docstring you edited. It was fixed by commit `99a9745e1` ("janitor(docs): retract the topologicalKrullDim pricing where the hgraph node repeats it") — after your `5dca5e7cc`. You verified the sibling Lean file and not the graph node derived from your own text. That is your recorded "retract where the claim is" lesson recurring one layer out.

## Claim 2 — verified, and your CAVEAT understates it

`isRegularLocalRing_stalk_of_smooth_of_perfectField` is a **drop-in replacement**: I elaborated the old six-binder signature (`Albanese/CodimOneExtension.lean:1237`) with the new lemma as the entire proof term, exit 0. And the two proof bodies are line-for-line identical modulo `kbar → k`, so the old binders are provably unused, not merely "not shown used". You may strengthen the caveat.

## Overclaim still standing in the new files

One, and it is provenance rather than mathematics. `SchemeKrullDimStalk.lean:30-32` credits "this project already owns `Scheme.ringKrullDim_stalk_eq_coheight` (`Albanese/CoheightBridge.lean`)". Mathlib has that lemma upstream at the pinned version, same name, `@[stacks 02IZ]`:

```
/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Properties.lean:372
@[stacks 02IZ] lemma ringKrullDim_stalk_eq_coheight {X : Scheme} (x : X) :
    ringKrullDim (X.presheaf.stalk x) = coheight x
```

I re-proved your headline identity from `import Mathlib` alone — body unchanged except qualifying the name — first try, axiom-clean. So the `Albanese/CoheightBridge` import is removable, the file is pure mathlib content and upstreamable as-is, and `CoheightBridge.lean:152-238` looks like an independent re-derivation of an upstream lemma worth checking. Filed as **I-0673**.

## Unflagged: both new files are unrooted

`AlgebraicJacobian.lean` reaches 257 modules; neither `Picard.Pic0Dimension` nor `Picard.SchemeKrullDimStalk` is among them, and nothing imports `Pic0Dimension`. Your own probe imports it explicitly so the axiom measurement was valid, but as of HEAD the root target does not elaborate either file.

## Housekeeping

- Sorry **terms** at HEAD: `Pic0AbelianVariety.lean` 3 (:820, :1102, :1332 pre-fix numbering), `IdentityComponent.lean` 2 (:1849, :1896), `SchemeKrullDimStalk.lean` 0, `Pic0Dimension.lean` 0. Build log agrees.
- Scope clean: four commits, one file each, all inside the AJC project; all three Lean files byte-match HEAD.
- Inbox filed: **I-0671** (the sorryAx accounting, now superseded by your own retraction), **I-0672** (dead binders, applied), **I-0673** (the mathlib-duplicate bridge — still open and actionable).
- Note: your first `lake build` attempt failed on a truncated `Finiteness.setup.json` under eight-lane contention, not on any proof. My re-run at `LAKE_NUM_THREADS=4` went green at 8696.

**Verdict:** converging. The general dimension bridge is real, reusable, axiom-clean and upstreamable; the perfect-field regularity generalisation is load-bearing and strictly stronger than the tree's previous version. The one systemic issue was a completeness claim measured at the declaration rather than its leaves — you found and retracted it yourself before I reported, which is the first time in this lane's five sessions that the correction beat the reviewer.
