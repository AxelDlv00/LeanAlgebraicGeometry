# Blueprint-writer directive — chapter `Picard_TensorObjSubstrate.tex` (iter-217)

You edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Do NOT touch
any `\leanok` / `\mathlibok` markers (the deterministic sync owns `\leanok`; the
review agent owns `\mathlibok`). Do not add or remove markers of any kind.

## Context (what changed, why this correction is needed)

This chapter blueprints the `Scheme.Modules.tensorObj` substrate (A.1.c.SubT) — the
hand-built commutative group on locally-trivial iso-classes (the relative Picard
group), which consumes only *existence* of the associator/unitor/braiding isos.
The single remaining substrate linchpin is `lem:tensorobj_restrict_iso` (tensor
commutes with restriction along an open immersion).

In iter-216 the prover ran a **make-or-break test** that the previous blueprint
rewrite had asserted: "the associator consumes `tensorObj_restrict_iso` only on a
*free trivialising cover*, where it follows from base-change-along-a-ring-iso alone,
WITHOUT the Mathlib-absent general presheaf-pushforward adjunction (H1)." **That
make-or-break returned NEGATIVE and is now refuted.** The decisive evidence:

- The sole consumer `tensorObj_isLocallyTrivial` applies `tensorObj_restrict_iso W.ι M N`
  to **arbitrary** `M N` — the restriction is commuted past the *sheafified* tensor
  `(tensorObj M N).restrict ≅ tensorObj (M|) (N|)` **before** the trivialisation
  witnesses `eM, eN` enter (they are used only in the next composition step). So the
  restriction lands on the GLOBAL `tensorObj M N` and cannot be trivialised first.
- Therefore the arbitrary-module statement, and with it **H1, is genuinely on the
  critical path.** There is no free-cover shortcut.

Consequently the path forward is to **BUILD H1** (the presheaf-level pushforward
adjunction), NOT to specialise to a free cover and NOT to revert to the superseded
route-(e) (`(J.W).IsMonoidal` / d.2, which is *harder* than H1). H1 has an exact
Mathlib *sheaf*-level template to mirror, `SheafOfModules.pushforwardPushforwardAdj`.

The iter-216 review also closed, axiom-clean, the **ModuleCat-level H2 core** (6 new
declarations) — the strong-monoidal upgrade of `ModuleCat.restrictScalars` along a
ring *isomorphism*. These are present in the Lean file but unpinned in the chapter.

## Required corrections (all MUST be done this iter)

### MUST-FIX 1 — `lem:tensorobj_restrict_iso` proof block (currently lines ~547–671)

1. **Delete** the `% NOTE (review iter-216): ...` comment at the top of the proof
   block (lines ~549–557). You are fixing the issue it flags, so the note is retired.
2. **Delete the entire trailing paragraph** beginning `\emph{The make-or-break: only
   the free-cover case is on the critical path.}` (lines ~650–671). It is REFUTED:
   the free-cover shortcut does not exist; the arbitrary-module statement is exactly
   what the consumer needs, and H1 is on the critical path. Remove it in full,
   including the "fallback / revert to route (e)" sentence.
3. **Keep and elevate "Step 3 (the genuine residual: H1 alone)"** (it is already
   correct). After deleting the make-or-break paragraph, ensure the proof ends with
   Step 3 as the *definitive, sole* remaining obligation: the presheaf-level
   identification `pushforward β ≅ pullback φ` via `Adjunction.leftAdjointUniq`, built
   from a presheaf-level adjunction `pushforward β ⊣ pushforward φ`, which is the
   presheaf analogue of the *sheaf*-level `SheafOfModules.pushforwardPushforwardAdj`
   and requires the Mathlib-absent presheaf-level `pushforwardNatTrans` and
   `pushforwardCongr` (whereas presheaf `pushforwardId` / `pushforwardComp` already
   exist). State plainly that this is the single open substrate obligation and that it
   is being built directly (Mathlib-gradient), not deferred to an upstream PR.
4. Add a `% SOURCE:` + `% SOURCE QUOTE:` citation for the mathematical content that
   the comparison rests on — the extension-/restriction-of-scalars adjunction
   (equivalently the `f^* ⊣ f_*` adjunction for (quasi-coherent) modules along a
   morphism, here an open immersion). Use a source you can open locally and quote
   VERBATIM. Acceptable, in order of preference: (a) Stacks "Modules" / "Sheaves of
   Modules" chapter — the pullback ⊣ pushforward adjunction for O-modules (e.g. the
   adjunction `f^* ⊣ f_*`), if present under `references/`; (b) Hartshorne II.5
   (the adjunction `Hom(f^*G, F) ≅ Hom(G, f_*F)`). If neither local source is
   available, you are AUTHORIZED to dispatch a `reference-retriever` child (your
   write-domain includes `references/**`) to fetch the Stacks tag, then quote it.
   Do NOT fabricate a quote — if retrieval fails, leave the block flagged
   `% SOURCE: <pointer> (verbatim text not yet retrieved)` and say so. The Mathlib
   template (`SheafOfModules.pushforwardPushforwardAdj`) is a CODE reference, cite it
   as such (file path), not as a `% SOURCE QUOTE`.

### MUST-FIX 2 — `lem:tensorobj_assoc_iso` proof block (currently lines ~1275–1371)

The Lean pin is currently realized via the **route-(d) three-step composite**
(`W_whiskerRight_of_W` / `W_whiskerLeft_of_W` / `isIso_sheafification_map_of_W` +
the presheaf associator), which transitively depends on the open, vestigial sorry
`isLocallyInjective_whiskerLeft_of_W`. The current blueprint proof falsely claims the
isomorphism is built by "*gluing canonical local isomorphisms* ... *no* whiskering ...
*no* `(J.W).IsMonoidal`" via `tensorObj_restrict_iso`. This contradicts the Lean.

Rewrite the proof block to be HONEST about both the current realization and the target:

1. **Delete** the `% NOTE (review iter-216): ...` comment at the top of the proof
   block (lines ~1277–1286).
2. **Delete the trailing `\emph{The free-cover make-or-break.}` paragraph**
   (lines ~1350–1370) — same refutation as MUST-FIX 1; remove the "free cover ⇒ no H1"
   and the route-(e) fallback sentence.
3. **State the current realization first** (matching the Lean): the associator is
   currently obtained by transporting the canonical *presheaf*-level associator
   `α` of `PresheafOfModules O_X` through sheafification, using the
   whiskering-stability lemmas `W_whiskerRight_of_W` / `W_whiskerLeft_of_W`
   (`lem:whisker_of_W`) to pull the inner sheafification out of the nested
   `tensorObj (tensorObj M N) P`, together with `isIso_sheafification_map_of_W`. Note
   that this current route is transitively gated on the open
   `isLocallyInjective_whiskerLeft_of_W` (`lem:islocallyinjective_whisker_of_W`).
4. **Then describe the planned re-route** as the target (NOT yet realized): once
   `lem:tensorobj_restrict_iso` is closed (via H1), the associator will be re-built by
   gluing the canonical local isos
   `((M⊗N)⊗P)|_U ≅ (M|⊗N|)⊗P| ≅ M|⊗(N|⊗P|) ≅ (M⊗(N⊗P))|_U`
   (two applications of `lem:tensorobj_restrict_iso` + the canonical presheaf
   associator), which agree on overlaps by naturality, glued via "Hom-of-sheaves is a
   sheaf". After the re-route the vestigial whiskering/`(J.W).IsMonoidal`/stalk
   apparatus is deleted. Keep the existing accurate paragraph about the overlap-
   naturality / gluing being genuine *global data* (stronger than the pointwise
   `lem:tensorobj_preserves_locally_trivial`). Make crystal clear which is "current"
   and which is "planned target", so the sketch matches the Lean as it stands today.

### MAJOR — pin the 5 substantive iter-216 H2 declarations

In `lem:restrictscalars_ringiso_tensorequiv` (currently lines ~673–698), or in a small
companion lemma block immediately after it, add `\lean{...}` pins and one-sentence
descriptions for the ModuleCat-level H2 core (all closed axiom-clean in iter-216):

- `restrictScalars_isIso_μ` — the lax tensorator `μ` of `restrictScalars e.toRingHom`
  is an iso (for a ring *iso* `e : R ≃+* S`).
- `restrictScalars_isIso_ε` — the lax unit `ε` is an iso.
- `restrictScalarsMonoidalOfRingEquiv` — the packaged *strong*-monoidal structure
  `(ModuleCat.restrictScalars e.toRingHom).Monoidal`.
- `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective` —
  the bijective-ring-hom forms (consumed by the presheaf-level lift, where
  `(α.app X).hom` is bijective but not literally `(_ : R ≃+* S).toRingHom`).

Explain in one or two sentences that these provide the ModuleCat-level H2 ("strong
restrictScalars along a ring iso commutes with ⊗") and that the *remaining* H2 step is
the bounded, no-Mathlib-gap PRESHEAF lift (build `(PresheafOfModules.restrictScalars α).Monoidal`
app-wise via `Functor.Monoidal.ofLaxMonoidal` + a CommRingCat-iso→Bijective bridge +
PresheafOfModules iso-iff-app-iso reflection), after which `pushforward β` is monoidal.
This presheaf H2 lift is bounded; the sole genuinely Mathlib-absent piece is H1.

## Out of scope (do NOT do)

- Do NOT re-introduce or rehabilitate the free-cover-avoids-H1 narrative anywhere.
- Do NOT promote route-(e) (`lem:jw_ismonoidal` / `lem:whisker_of_W` /
  `lem:islocallyinjective_whisker_of_W`) from "superseded / off-path" to a live route;
  it stays documented as superseded. (It remains the *named* fallback only if H1 itself
  bottoms out — you may keep one sentence to that effect, but do not present it as the
  plan.)
- Do NOT touch the unitor/braiding/IsInvertible/group-law blocks except where a
  cross-reference to the deleted make-or-break text needs cleaning.
- Do NOT add `\leanok` / `\mathlibok`.

## Report

In your report, list exactly which blocks you edited, what you deleted, the source you
quoted (file + tag) for the adjunction, and flag under "Strategy-modifying findings"
anything the prose surfaced that contradicts the H1-build plan.
