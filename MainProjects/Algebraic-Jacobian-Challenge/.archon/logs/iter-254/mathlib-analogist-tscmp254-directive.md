# mathlib-analogist directive — tscmp254

## Mode: cross-domain-inspiration

## Structural problem

We are proving a **naturality square for a comparison morphism between sheafified module-presheaves over
a scheme**, at the presheaf level after a `congr 1` reduction. The goal has the shape (all in a single
presheaf-of-modules category over the structure sheaf of rings):

> `(p ⊗ₘ q) ≫ (η_{P'} ▷ Q' ≫ a.val ◁ η_{Q'})  =  (η_P ▷ Q ≫ a.val ◁ η_Q) ≫ (ā ⊗ₘ b̄)`

where `η` is a **sheafification unit** (`presheafToSheaf` adjunction unit), `▷`/`◁` are monoidal
whiskerings, `⊗ₘ` is the tensor of morphisms, and the objects are `PresheafOfModules` over a
`RingCat`-valued sheaf of rings on the scheme's topological space. The hand-derivation is
mathematically complete (expand `tensorHom_def`, apply `whisker_exchange`, fold the two unit-naturality
facts `p ≫ η_{P'} = η_P ≫ a.val`, re-expand). It is a routine bifunctor/whiskering calculation.

**The obstruction is purely structural/elaboration-level, recurring for ~11+ iters on this route:**

1. **Two defeq-but-distinct monoidal `≫`/instance spellings collide.** Half the terms carry
   `MonoidalCategoryStruct` projections coming from one lemma (`whiskerRight/whiskerLeft`), the other
   half carry `MonoidalCategory.toMonoidalCategoryStruct` projections coming from `tensorHom_def`. Plain
   `rw [Category.assoc]` / `whisker_exchange` report "pattern not found"; `erw` bridges them but then
   triggers a **catastrophic `whnf`** because the sheafification unit's codomain is
   `restrictScalars (𝟙 R) (a.val)` over a sheafification — the keyed-defeq `whnf` does not terminate even
   at 6.4M heartbeats (deterministic timeout).

2. **The `restrictScalars (𝟙 R)` identity-restriction wrapper** sits on the sheafification unit's
   codomain and refuses to normalize away — it is the persistent friction source (it gated the
   sibling lemma D2′ for 11 iterations before a bespoke unit-pair workaround closed that one case).

3. **Extracting the presheaf identity to a uniform-instance helper FAILS at the statement level:**
   `MonoidalCategory.whiskerLeft ((sheafification …).obj P').val (η Q')` cannot synthesize
   `MonoidalCategoryStruct (PresheafOfModules X.ringCatSheaf.obj)` — that **ring-functor spelling**
   (`X.ringCatSheaf.obj` vs `Sheaf.val X.ringCatSheaf`) lacks the monoidal instance; only the
   defeq-massaged in-context term carries it. A sibling lemma (D1′ `pullbackTensorMap_natural`) is ALSO
   blocked on the SAME spelling split: `Functor.comp_map` produces `sheafification (𝟙 Y.ringCatSheaf.obj)`
   while a neighbouring factor reads `sheafification (𝟙 (Sheaf.val Y.ringCatSheaf))`, and
   `← Functor.map_comp` will not merge them ("pattern not found"; a `show … = … from rfl` rewrite hits
   "motive is not type correct" because the functor sits in dependent positions).

## What I'm really asking

The project suspects the ROOT is a **non-canonical / inconsistent spelling of the base ring functor and
the identity-restriction wrapper**, causing (a) the monoidal instance not to be found on the "clean"
spelling and (b) two defeq monoidal `≫` groups that no rewrite can bridge without `erw`+`whnf`-explosion.

Please bring back, with Mathlib citations:

1. **How Mathlib states and USES the monoidal structure on `PresheafOfModules` / `SheafOfModules` over a
   sheaf of rings** — what is the *canonical* spelling of the base ring object the monoidal instance is
   registered against, and how do Mathlib proofs keep all whiskering/tensor terms in ONE instance so
   that `whisker_exchange`/`tensorHom_def`/`Category.assoc` fire by plain `rw` (no `erw`)? Is there a
   `simp`-normal form or a canonical `@[simp]` lemma that pins the ring-functor / `Sheaf.val` spelling?

2. **How Mathlib handles `restrictScalars (𝟙)` (identity ring map) so it normalizes away** — is there a
   `restrictScalarsId`/`restrictScalarsId'`-style `simp` lemma or `NatIso` that strips the identity
   base-change wrapper BEFORE it reaches a whiskering/`whnf`, in `ModuleCat`, `PresheafOfModules`, or any
   other category of modules-over-a-varying-base in Mathlib?

3. **Cross-domain precedent**: has Mathlib solved "naturality of a (co)unit of an adjunction composed
   with a monoidal whiskering, where the unit codomain carries an identity base-change wrapper" in ANY
   monoidal-adjunction setting (e.g. `Mon_`/`Comon_`, sheafification-is-monoidal `Sites.Monoidal`,
   localization-of-modules, `Action`/`Rep`, graded modules, filtered colimits)? What TECHNIQUE bridged
   the two defeq instance groups there — a normalization lemma, a `change`/`show` reshape, a dedicated
   `MonoidalCategoryStruct`-transport, or restating the comparison map on a single spelling?

## Failed approaches (do not re-suggest)
- `letI`-based instance unification of the two monoidal structs — **disproven iter-252** (`whisker_exchange`
  cannot bridge the cross-group crossing even via `erw`).
- `erw`-driven `≫`-instance bridge — triggers the non-terminating `whnf` (approach failed iter-253).
- Extracting a uniform-instance helper lemma on the `X.ringCatSheaf.obj` spelling — `synthInstanceFailed`
  ×4 (the clean spelling lacks the monoidal instance).
- Element-level descent (`TensorProduct.induction_on`) — reduces to a presheaf identity but the same
  instance/whnf split blocks the final whisker step.

## Search radius: narrow (Mathlib's sheaf/presheaf-of-modules, monoidal-category, and module-base-change
areas — same general area as the project, different sub-areas welcome).

## Deliverable
A ranked list of concrete portable techniques (with `Mathlib.…` citations) the project can try, and a
clear verdict: is the right fix (i) a **spelling-normalization** (pin one ring-functor / strip
`restrictScalars (𝟙)` by a `simp` lemma) that makes plain `rw` fire — and if so WHICH Mathlib lemma —
or (ii) a genuinely different proof architecture for this naturality square. If you conclude the clean
fix is to **restate the comparison map `pullbackTensorMap` and its helper isos on a single canonical
ring-functor spelling**, say so explicitly and name the canonical spelling Mathlib uses.
