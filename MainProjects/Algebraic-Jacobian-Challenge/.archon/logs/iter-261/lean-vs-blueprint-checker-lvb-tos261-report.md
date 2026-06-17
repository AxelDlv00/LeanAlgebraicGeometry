# Lean ↔ Blueprint Check Report

## Slug
lvb-tos261

## Iteration
261

## Files audited
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Scope this iteration

Iter-261 prover work on this file:
1. **New sub-lemma `sheafificationCompPullback_comp`** (`private lemma`, ~L2439) — the Sq1 foundational coherence for D3′, extracted and opened with a typed `sorry` that leaves the unit-reassembly step to the next iteration.
2. **`pullbackTensorMap_restrict`** (`lemma`, ~L2503) — D3′ main statement, opened to "paste-ready form" (both sides unfolded via `simp only [pullbackTensorMap, tensorObjIsoOfIso]` + `Functor.map_comp`) with a typed `sorry` for the remaining 4-vs-10 factor assembly.
3. **`pullbackComp_δ`** and **`pushforwardComp_lax_μ`** — both `private`, Sq2b — are sorry-free (CLOSED, no sorries found in L2246–2426). Consistent with the blueprint's "Sq2b fully discharged" claim.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`)
- **Lean target exists**: yes — `lemma pullbackTensorMap_restrict` at L2503
- **Signature matches**: yes — blueprint (lines 3868–3888) states
  ```
  δ_{sheaf}^{h∘f}(M,N) = (pullbackComp h f).inv_{M⊗N}
    ; h^*(δ_{sheaf}^f(M,N))
    ; δ_{sheaf}^h(f^*M, f^*N)
    ; tensorObjIsoOfIso((pullbackComp h f)_M, (pullbackComp h f)_N).hom
  ```
  and the Lean (L2503–2511) reads verbatim:
  ```lean
  pullbackTensorMap (h ≫ f) M N =
    (Scheme.Modules.pullbackComp h f).inv.app (tensorObj M N) ≫
    (Scheme.Modules.pullback h).map (pullbackTensorMap f M N) ≫
    pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
      ((Scheme.Modules.pullback f).obj N) ≫
    (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
      ((Scheme.Modules.pullbackComp h f).app N)).hom
  ```
  Exact match.
- **Proof follows sketch**: partial — the sketch in the blueprint correctly identifies the 4-square structure (Sq2, Sq2b, Sq1, Sq3, Sq4); the Lean proof comment at L2512–2598 follows this roadmap faithfully. The OPENED proof correctly applies `simp only [pullbackTensorMap, tensorObjIsoOfIso]` and `Functor.map_comp` to expose the 4-vs-10 factor identity, then carries a typed `sorry` for the remaining assembly (Sq1 unit-reassembly + Sq4 sub-lemma still open).
- **`\leanok` status**: statement block has `\leanok` (blueprint L3862) — correct (declaration exists with sorry). No proof-block `\leanok` — correct (sorry present).
- **Notes**: Typed sorry at L2598 is clearly tracked with a full roadmap. No concern.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` (chapter: `lem:sheafification_comp_pullback_eq_leftadjointuniq`, blueprint L3730)
- **Lean target exists**: yes — `lemma sheafificationCompPullback_eq_leftAdjointUniq` at L1598 (referenced in `sheafificationCompPullback_comp`'s proof via `rw [sheafificationCompPullback_eq_leftAdjointUniq]` at L2460).
- **Signature matches**: yes (not directly audited this iter but used correctly in the new sub-lemma proof).
- **Proof follows sketch**: N/A — already marked `\leanok` on proof block and sorry-free.

### (all other `\lean{...}` blocks in the chapter)
No changes or regressions noted from earlier iters. All previously-closed sorry-free declarations remain sorry-free. The newly-added Sq2b lemmas (`pullbackComp_δ`, `pushforwardComp_lax_μ`) are `private` and verified sorry-free at L2246–2426.

---

## Red flags

### Stale status comment (major)
- `TensorObjSubstrate.lean:39–44`: Module header `## Status (current)` says:
  > "There is now **ONE** tracked typed-`sorry` residual: the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L690, cross-file gated...)"
  
  This was accurate before iter-261 but is now stale: the file has **three** `sorry`s:
  - L715: `exists_tensorObj_inverse` (cross-file gated, out-of-scope)
  - L2480: `sheafificationCompPullback_comp` (Sq1 — new this iter, typed sorry)
  - L2598: `pullbackTensorMap_restrict` (D3′ — new opened this iter, typed sorry)
  
  The statement "ONE tracked typed-sorry residual" misrepresents the current proof state. Anyone auditing the file from the module comment alone would incorrectly conclude only one sorry remains. This does not excuse wrong code but does mislead the proof-state audit.

### Placeholder / suspect bodies
None. All three `sorry`s are typed (detailed proof roadmaps in proof comments); none is a bare placeholder.

### Excuse-comments
None found. Proof comments at L2512–2598 are technical/mathematical, describe the correct mathematical approach, and identify the *specific missing pieces* (Sq1 unit-reassembly, Sq4 pullbackValIso coherence). These are acceptable typed-sorry annotations, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None. The file's existing sorry-free declarations use only `propext`, `Classical.choice`, and `Quot.sound` (per prior audit; no new `axiom` declarations this iter).

---

## Unreferenced declarations (informational)

All new private declarations are `private lemma`, so no `\lean{}` pin is required or expected:

| Declaration | Kind | Status | Note |
|---|---|---|---|
| `sheafificationCompPullback_comp` (L2439) | `private lemma` | has `sorry` (typed) | New Sq1 sub-lemma; blueprint names it "standalone project sub-lemma" without giving the Lean name. Acceptable since `private`. |
| `pullbackComp_δ` (L2307) | `private lemma` | sorry-free | Sq2b core; referenced inline in blueprint's Sq2b narrative. |
| `pushforwardComp_lax_μ` (L2246) | `private lemma` | sorry-free | Sq2b residual; referenced inline. |
| `toRingCatSheafHom_comp_hom_reconcile` (L2121) | `private lemma` | sorry-free (`rfl`) | Sq2 ring-map reconciliation; blueprint correctly identifies this as definitional. |
| `restrictScalars_μ_app` / `forget₂_restrictScalars_μ_hom_tmul` / `pushforward_map_restrictScalars_μ_app_tmul` / `pushforward_μ_eq` (L2127–L2245) | `private lemma` | sorry-free | Auxiliary helpers for `pushforwardComp_lax_μ`; no blueprint pin needed. |

---

## Blueprint adequacy for this file (D3′ section focus)

- **Coverage**: The two `\lean{}`-pinned main declarations for D3′ (`pullbackTensorMap_restrict` at blueprint L3865 and `sheafificationCompPullback_eq_leftAdjointUniq` at L3735) exist and are correctly pinned. The new `private lemma sheafificationCompPullback_comp` (Sq1) has no pin — acceptable since `private`. Overall coverage is adequate for the exported declarations.

- **Proof-sketch depth**: **Under-specified on two points (minor)**:
  1. **Sq1's exact statement form**: The blueprint at lines 4055–4060 describes Sq1 only as "the composition coherence of `SheafOfModules.sheafificationCompPullback` across h ∘ f ... absent from Mathlib and is supplied as a standalone project sub-lemma (mate-calculus style)." It does not spell out the 4-term RHS of `sheafificationCompPullback_comp`:
     ```
     (pullbackComp h f).inv.app (a_X.obj P)
       ≫ (pullback h).map ((sheafCompPb f).app P).hom
       ≫ (sheafCompPb h).app (PresheafOfModules.pullback φ'_f P).hom
       ≫ a_Z.map ((PresheafOfModules.pullbackComp φ'_f φ'_h).hom.app P)
     ```
     This requires a prover to re-derive the signature from first principles. Since the Lean file already has the `private lemma` with the correct statement (from this iter), this only blocks provers who need to work from the blueprint without the Lean file.
  2. **Factor interleaving in the 4-square paste**: The blueprint (lines 3912–3936) describes D3′'s proof as "a paste of four commuting squares." The Lean proof comment at L2583–2592 identifies a critical subtlety: "The squares INTERLEAVE (e.g. `S1_h` here acts on `tensorObj ((pullback f).obj M) …`, NOT on `PrPb_f (M⊗N)`), so the paste slides factors past each other by `δ_natural` / NatTrans naturality exactly as the D1′ naturality paste does — merging `a.map δ ≫ S3 ≫ S4` into a single `a.map Ψ` to move S1 by its mate coherence." This interleaving aspect is absent from the blueprint's proof sketch, making the "four commuting squares" description potentially misleading (naive row-by-row paste does not work).

- **Hint precision**: Precise for the main D3′ declaration. The `\lean{}` hint `AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict` is correct and unambiguous.

- **Generality**: Matches need. The Sq4 (pullbackValIso composition coherence) sub-lemma is not yet a Lean declaration — the blueprint correctly identifies it as a missing ingredient without overpromising a form.

- **`\uses` field**: The D3′ statement block's `\uses` field (blueprint L3866–3867) includes `lem:tensorobj_restrict_iso`. This lemma computes the restriction of `tensorObj M N` to an open subscheme; it does not appear in D3′'s proof sketch and the Lean proof roadmap does not reference it. This may be a stale dependency tag (minor).

- **Recommended chapter-side actions**:
  1. (Minor) Add the name `sheafificationCompPullback_comp` (annotated as `private`) to the Sq1 description (line 4055) so future provers can find the sub-lemma skeleton without re-deriving the 4-term signature.
  2. (Minor) Expand the Sq1 description to include the exact 4-term RHS of the composition coherence statement.
  3. (Minor) Add a sentence to the "paste of four commuting squares" paragraph noting that the squares interleave — the paste cannot proceed row-by-row because S1_h acts on `tensorObj ((pullback f).obj M)` rather than on `PresheafOfModules.pullback φ'_f (M⊗N)`, so factors must be slid past each other via naturality before assembly.
  4. (Minor) Remove `lem:tensorobj_restrict_iso` from D3′'s statement `\uses` if it is stale.

---

## Severity summary

- **Must-fix-this-iter**: None.
- **Major** (1):
  - `TensorObjSubstrate.lean:39–44`: Module header "Status (current)" says "ONE tracked typed-sorry residual" — stale, there are now **three** (L715, L2480, L2598). Misleads proof-state auditors.
- **Minor** (4):
  - Blueprint Sq1 description (L4055) lacks the Lean sub-lemma name and its exact 4-term signature.
  - Blueprint D3′ proof sketch omits the factor-interleaving difficulty in the 4-square paste.
  - No precise statement form for Sq4 (pullbackValIso coherence) in the blueprint.
  - `\uses{lem:tensorobj_restrict_iso}` in D3′'s statement block is likely stale.

**Overall verdict**: The Lean file faithfully follows the blueprint for the D3′/Sq decomposition; the new `sheafificationCompPullback_comp` sub-lemma correctly isolates Sq1 and matches the blueprint's structural description; both open sorries are well-typed with complete proof roadmaps. The stale module-header sorry-count (says ONE, should be THREE) is the sole actionable major finding; four minor blueprint-adequacy gaps should be addressed before the next prover dispatch on Sq1.
