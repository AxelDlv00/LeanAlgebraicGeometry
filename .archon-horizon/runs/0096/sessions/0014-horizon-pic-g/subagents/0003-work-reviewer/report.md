Audit complete. Filed I-1657, I-1658, I-1659 (issues) and I-1660 (memory). No files edited; probe files removed.

## Verdict: real but substantially thinner than advertised

The Lean is correct and green. What is overclaimed is the *value*: the two headline producers weaken nothing, and 60 of the file's lines are subsumed by another lemma in the same file. Priority 1 and 4 are the load-bearing findings.

---

### 1. `subsingleton_of_away` / `rigidity_of_away` — CONFIRMED as claimed (this one is fine)

CLAIM: "This file attacks the **quantifier** rather than the content" via one application of `eq_of_away_eq`.

VERDICT: **confirmed, correctly self-priced.** `subsingleton_of_away` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RingZariskiLocal.lean:189`) is literally a one-line rewrapping — `⟨fun _ _ => eq_of_away_eq C g S hg fun i => Subsingleton.elim _ _⟩`. Its own docstring says "One application of the landed separation half," so nothing is hidden. `rigidity_of_away:202` is more than an instantiation: the 4-line proof carries the field point *backwards* along `A → S i` via `mapAlg_comp`, which is a real (if small) step and is the one the docstring correctly highlights. Your framing "QUANTIFIER reduction" is accurate for the pair. `eq_of_away_eq` itself (`PicEtAffZariskiSep.lean:137`, ~85 lines) is where the work is, and it was landed earlier.

### 2. The pointwise form — hypothesis is NOT weaker (at the shape the producers use)

CLAIM (line 66): "**the pointwise form, and the one a consumer wants**: no covering family in the statement."

VERDICT: **overclaimed.**

(a) At a *fixed* `A`, the pointwise hypothesis is genuinely weaker than the global one — that much is real. But see finding 4: no consumer in the file uses the fixed-`A` shape.

(b) Yes, it quantifies over all primes, and degenerate basic opens are harmless: `f = 1` is a legal witness at every prime, and `Localization.Away 1 ≃ A`. That is exactly why (a) collapses under the outer quantifier.

(c) `span_eq_top_of_forall_prime:257` **is** in mathlib: `PrimeSpectrum.iSup_basicOpen_eq_top_iff'`, `.lake-packages/mathlib/Mathlib/RingTheory/Spectrum/Prime/Topology.lean:636`. I closed the file's exact statement with

```lean
rw [← PrimeSpectrum.iSup_basicOpen_eq_top_iff']; ext p; simpa using h p
```

EXIT=0. Bare `exact?` does fail on it, which is presumably what licensed the rewrite — `exact?` failing is not absence.

### 3. The degenerate ring — chain is real, result is VACUITY, "settles" is overclaimed

CLAIM (line 145): "This settles the open question of `I-1655` … the affine spelling is **satisfied** rather than refuted at that site."

VERDICT: **overclaimed, and the section is redundant with the same file.**

The four-step chain is real and each step is honest (`PrimeSpectrum.isEmpty_iff_subsingleton` → project along `snd` → `Scheme.CechPic.subsingleton_of_subsingleton`, confirmed at `Pic.lean:257` → étale covers of a subsingleton stay subsingleton). But the entire 60-line section (`:102`, `:117`, `:133`, `:151`) is the **vacuous-hypothesis instance of `PicEtAff.subsingleton_of_forall_prime:274` from the same file** — `Spec A` is empty, so the pointwise hypothesis dies to `isEmptyElim`. I reproved all three variants in 3 lines each, EXIT=0:

```lean
haveI : IsEmpty (PrimeSpectrum A) := PrimeSpectrum.isEmpty_iff_subsingleton.mpr ‹_›
exact PicEtAff.subsingleton_of_forall_prime C (fun p => isEmptyElim p)
```

On your harder question: this is a **vacuity** result. At subsingleton `A`, the antecedent, the pointwise hypothesis, and the conclusion are all vacuous together. It says nothing about inhabitability of `hrigAff` at any `A` with a nonempty spectrum, which is what the I-1655 addendum actually asked ("it decides whether the affine spelling is inhabitable at all" — it does not). "Settles" should be "the cheapest refutation site is not a counterexample."

### 4. The `JacobianData` producers — hypotheses provably EQUIVALENT to the pre-existing global ones

CLAIM (line 338): "the *pointwise-local* hypothesis … produces the datum through the landed producers"; "This is the shortest statement of the whole vanishing route's remaining debt."

VERDICT: **false as a weakening / overclaimed as progress.** This is the finding that matters most.

Both producers quantify the pointwise clause over **every** test algebra `A`. But `Localization.Away f` *is itself a test algebra*, so the outer `∀A` re-consumes the localisation. I proved the full biconditional against the pre-existing `jacobianData_of_affine_subsingleton` hypothesis (`Pic0VanishingRoute.lean:296`) and against `hrigAff`, EXIT=0 for both. The backward direction is one line with witness `f = 1`:

```lean
fun A _ _ p => ⟨1, fun hc => p.isPrime.ne_top (Ideal.eq_top_of_isUnit_mem _ hc isUnit_one),
  h (Localization.Away (1 : A))⟩
```

So `jacobianData_of_forall_prime_subsingleton:355` and `_rigidity:369` take hypotheses **logically equivalent** to producers that already existed. They are compositions a consumer could write inline (each body is one line already), and they buy no reduction of the debt.

On inhabitability: producers of `Subsingleton (PicEtAff C A)` at HEAD are the subsingleton ring (this file) and nothing else — every other hit in the grep is a *consumer* binder. So the non-vacuity witness for both producers is the degenerate ring, exactly as you feared.

### 5. Header claims

| Claim | Verdict | Evidence |
|---|---|---|
| `Subsingleton (CommRing.Pic (Polynomial A))` does not follow from `IsLocalRing A` | **confirmed** | `exact?`/`infer_instance` both fail. Also confirmed `CommRing.Pic.instSubsingletonOfFiniteMaximalSpectrum` exists and *does* fire for `IsLocalRing A` on `Pic A` itself. |
| Only the SEPARATION half is used; the gluing half is not | **confirmed** | Proof-term closure scan over all five main declarations: `ZariskiGlue` modules = `[]` in every case, including the two `JacobianData` producers (7784 constants, 32 AJ modules). |
| Seminormality is absent from mathlib | **confirmed** | zero files match `seminormal` (case-insensitive) across `Mathlib/`. |
| "No new hypothesis is added to any existing statement" | **confirmed** | every theorem takes covering data explicitly or is unconditional on a degenerate ring; instance binders match the producers they compose with. |
| Line citations `PicEtAffZariskiSep.lean:137`, `Pic0VanishingAffineReduction.lean:269`, `Pic0RigidityAffineReduction.lean:190`, `Pic.lean:257` | 2 of 4 **off by 3** | `eq_of_away_eq` at 137 ✓, `Pic.lean:257` ✓; `jacobianData_of_overSpec_subsingleton` is at **266** not 269; `jacobianData_of_rigidityAff` is at **240** not 190 (190 is `rigidityAff_of_rigidity`). |
| Line 43 cites `subsingleton_picEtAff_of_subsingleton` | **false — dangling name** | no such declaration anywhere in the project; grep returns exactly one hit, the docstring itself. The theorem is `PicEtAff.subsingleton_of_subsingleton`. |
| "the interface a lane computing `Pic` over **local rings** should target" (lines 30, 272) | **false** | `IsLocalRing (Localization.Away f)` does not synthesize (`exact?` fails). A genuinely local computation produces `Localization.AtPrime`, and nothing in this file or the project bridges `AtPrime` to `Away`. That bridge is the real unbuilt step. |

### Provenance note

The three cited commits are smaller than the release implies. `5fdd296638` is a **one-token change** (`show` → `change`, 1 insertion / 1 deletion). The degenerate section and both `_of_away` reductions — 223 lines, the majority of the file — landed earlier under `f2464df73a` (session `0014-horizon-pic-c`, run 0092). This session's actual new content is `777a483fb5` (+84: the mathlib-duplicate span lemma and two pointwise forms) and `bece4578ad` (+75: the rigidity pointwise form and the two producers). Findings 2 and 4 hit essentially all of it.
