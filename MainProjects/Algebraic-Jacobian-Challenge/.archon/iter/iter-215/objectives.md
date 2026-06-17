# Iter-215 objectives (detail)

## Dispatched lane (1 file)

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — [prover-mode: prove]

**Goal:** close the line-bundle ⊗-group law via the LOCALLY-TRIVIAL-FIRST route (strategy-critic
ts215 pivot). FINAL one-iter gate (progress-critic ts215): the sorry count MUST decrease this iter
(close `isLocallyInjective_whiskerLeft_of_W`), else iter-216 escalates the substrate to USER.

Open sorries entering (4): `isLocallyInjective_whiskerLeft_of_W` (L411, target),
`tensorObj_restrict_iso` (L901, now critical), `exists_tensorObj_inverse` (L1009),
`addCommGroup_via_tensorObj` (L1049, RPF consumer, off-path).

**Step 1 — `tensorObj_restrict_iso` (L901).** Close the Step-3 presheaf-level comparison
(`pushforward β ≅ pullback φ` via `Adjunction.leftAdjointUniq` + strong-monoidal `restrictScalars`
along `f.appIso`). Recipe `informal/tensorObj_restrict_iso.md` + blueprint Step 3.

**Step 2 — `isLocallyInjective_whiskerLeft_of_W` (L411), locally-trivial route.** Specialise to
`[LineBundle.IsLocallyTrivial F]` (unprotected decl; sole consumer is the locally-trivial-scoped
associator). On a trivializing cover `F|_V ≅ 𝒪_V`: `tensorObj_restrict_iso` + left unitor give
`(F ◁ g)|_V ≅ g|_V`; `g ∈ J.W` stable under restriction ⟹ `g|_V` locally injective; local
injectivity is local on the cover. NO stalks, NO d.2. Sheaf-level — NOT the iter-213 section-level
Tor₁ dead end.

**Step 3 — `tensorObjIsoclassCommMonoid`.** Build directly on locally-trivial iso-classes à la
`Module.Invertible`: op `[L]·[M]=[L⊗M]`, identity `[𝒪_X]`, inverse from `exists_tensorObj_inverse`
(close L1009), associativity `tensorObj_assoc_iso`, unitors, braiding. No `LocalizedMonoidal`/`Skeleton`.

**Doc cleanup (lean-auditor ts214):** refresh stale "typed sorry" docstrings on `tensorObj` /
`tensorObj_functoriality`; remove the removed-`monoidalCategory` reference in the module status; fix
the `FlatWhisker` header contradiction.

**FALLBACK (NOT this iter):** route (e) `(J.W).IsMonoidal` → `LocalizedMonoidal` via d.2
(`stalkTensorComparison` on `ColimitFunctor.ModuleColimit`; recipe `analogies/ts-d2-feasibility-215.md`).
Multi-iter per the analogist; the d.1-core `stalkLinearMap*` stays for that path.

## Not dispatched (rationale in PROGRESS.md "Held lanes")

RPF (re-opens post TS group), FGA (post RPF), Quot engine (gated + USER RR decision), Albanese
Route-1 cone (superseded), Route 2 (gated A.2.c), WD (USER sig), RCI (Route C paused), A.3.* (USER #4).

## Gate-clearing record

Blueprint `Picard_TensorObjSubstrate.tex` rewritten this iter (ts-stalk215 + ltfirst215, clean
ts215). Fast-path reviewer: ts215fp NOT-CLEARED (1 stale "off critical path" sentence) → ts215fp2
NOT-CLEARED (2 more of the same) → plan agent fixed all 5 stale annotations → ts215fp3 re-review for
the CLEARED verdict before the prover runs.
